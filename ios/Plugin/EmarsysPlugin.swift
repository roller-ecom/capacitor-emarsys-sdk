import Foundation
import Capacitor
import EmarsysSDK

@objc(EmarsysPlugin)
public class EmarsysPlugin: CAPPlugin {
    private var predictHandler = EmarsysPredict();
    private var inboxHandler = EmarsysInbox();
    private var configHandler = EmarsysConfig();
    
    private var savedRegisterCall: CAPPluginCall? = nil;
    public var registered: Bool = false;
    private var messageStack = [StackedMessage]();
    
    override public func load() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRegisterWithToken(notification:)), name: .emarsysRegisterWithToken, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didFailedToRegister(notification:)), name: .emarsysRegisterFailed, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveRemoteNotification(notification:)), name: .emarsysReceivedRemoteNotification, object: nil)
        
        let mobileEngageApplicationCode = self.getConfig().getString("mobileEngageApplicationCode");
        let merchantId = self.getConfig().getString("merchantId");
        let consoleLogLevels = self.getConfig().getArray("consoleLogLevels") as? [String];
        
        let config = EMSConfig.make { builder in
            if(mobileEngageApplicationCode != nil) {
                builder.setMobileEngageApplicationCode(mobileEngageApplicationCode!)
            }
            if(merchantId != nil) {
                builder.setMerchantId(merchantId!)
            }
            if(consoleLogLevels != nil && consoleLogLevels!.count > 0) {
                var logs = [EMSLogLevelProtocol]();
                consoleLogLevels?.forEach { log in
                    switch log {
                    case "trace":
                        logs.append(EMSLogLevel.trace);
                    case "debug":
                        logs.append(EMSLogLevel.debug);
                    case "info":
                        logs.append(EMSLogLevel.info);
                    case "warn":
                        logs.append(EMSLogLevel.warn);
                    case "error":
                        logs.append(EMSLogLevel.error);
                    case "basic":
                        logs.append(EMSLogLevel.basic);
                    default:
                        print("Unknown LogLevel: " + log)
                    }
                }
                builder.enableConsoleLogLevels(logs);
            }
        }
        
        Emarsys.setup(config: config);
        
        // Handle push
        UNUserNotificationCenter.current().delegate = Emarsys.push
        
        let eventHandler = { eventName, payload in
            self.sendMessage(eventName: eventName, payload: payload);
        };
        
        Emarsys.push.notificationEventHandler = eventHandler;
        Emarsys.push.silentMessageEventHandler = eventHandler;
        Emarsys.inApp.eventHandler = eventHandler;
        Emarsys.onEventAction.eventHandler = eventHandler;
        
        Emarsys.push.silentMessageInformationBlock = {notificationInformation in
            self.sendSilentMessageInformation(block: notificationInformation);
        }
    }
    
    @objc func didRegisterWithToken(notification: NSNotification) {
        Emarsys.push.setPushToken(notification.object as! Data)
        if(self.savedRegisterCall != nil) {
            let deviceToken = (notification.object as! Data).reduce("", {$0 + String(format: "%02X", $1)})
            self.savedRegisterCall!.resolve(["token": deviceToken])
            self.savedRegisterCall = nil;
        }
        self.registered = true;
        self.sendStacked();
    }
    
    @objc public func didFailedToRegister(notification: NSNotification) {
        if(self.savedRegisterCall == nil) {
            return;
        }
        let error = notification.object as! Error
        self.savedRegisterCall!.reject(error.localizedDescription)
        self.savedRegisterCall = nil
    }
    
    @objc public func didReceiveRemoteNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let completionHandler = notification.object as! (UIBackgroundFetchResult) -> Void
        Emarsys.push.trackMessageOpen(userInfo: userInfo);
        Emarsys.push.handleMessage(userInfo: userInfo);
        completionHandler(.newData);
    }
    
    @objc override public func requestPermissions(_ call: CAPPluginCall) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard error == nil else {
                call.reject(error!.localizedDescription)
                return
            }
            
            var result: PushNotificationsPermissions = .denied
            
            if granted {
                result = .granted
            }
            
            call.resolve(["receive": result.rawValue])
        }
    }
    
    @objc override public func checkPermissions(_ call: CAPPluginCall) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            var result: PushNotificationsPermissions = .prompt
            
            switch settings.authorizationStatus {
            case .notDetermined:
                result = .prompt
            case .denied:
                result = .denied
            case .ephemeral, .authorized, .provisional:
                result = .granted
            @unknown default:
                result = .prompt
            }
            
            call.resolve(["receive": result.rawValue])
        }
    }
    
    @objc func register(_ call: CAPPluginCall) {
        if(self.savedRegisterCall != nil) {
            return
        }
        
        self.savedRegisterCall = call;
        
        #if targetEnvironment(simulator)
            // Simulator detected - resolve immediately with mock token
            call.resolve([
                "value": "SIMULATOR_TOKEN_FOR_TESTING"
            ])
            self.savedRegisterCall = nil
        #else
            // Real device - proceed normally
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        #endif
    }
    
    @objc func setContact(_ call: CAPPluginCall) {
        Emarsys.setContact(contactFieldId: call.getInt("contactFieldId")! as NSNumber, contactFieldValue: call.getString("contactFieldValue")!) { error in
            guard error == nil else {
                call.reject(error!.localizedDescription)
                return
            }
            
            call.resolve();
        }
    }
    
    @objc func setAuthenticatedContact(_ call: CAPPluginCall) {
        Emarsys.setAuthenticatedContact(contactFieldId: call.getInt("contactFieldId")! as NSNumber, openIdToken: call.getString("openIdToken")!) { error in
            guard error == nil else {
                call.reject(error!.localizedDescription)
                return
            }
            
            call.resolve();
        }
    }
    
    @objc func clearContact(_ call: CAPPluginCall) {
        Emarsys.clearContact { error in
            guard error == nil else {
                call.reject(error!.localizedDescription)
                return
            }
            
            call.resolve();
        }
    }
    
    @objc func getPushToken(_ call: CAPPluginCall) {
        let deviceToken = Emarsys.push.pushToken()?.reduce("", {$0 + String(format: "%02X", $1)})
        if(deviceToken != nil) {
            self.registered = false;
            call.resolve(["token": deviceToken!])
        } else {
            call.reject("PushToken not exists")
        }
    }
    
    @objc func clearPushToken(_ call: CAPPluginCall) {
        Emarsys.push.clearPushToken { error in
            guard error == nil else {
                call.reject(error!.localizedDescription)
                return
            }
            
            call.resolve();
        }
    }
    
    // In-App
    
    @objc func pauseInApp(_ call: CAPPluginCall) {
        Emarsys.inApp.pause();
        call.resolve();
    }
    
    @objc func isInAppPaused(_ call: CAPPluginCall) {
        call.resolve(["isPaused": Emarsys.inApp.isPaused()]);
    }
    
    @objc func resumeInApp(_ call: CAPPluginCall) {
        Emarsys.inApp.resume();
        call.resolve();
    }
    
    // Predict
    
    @objc func trackItem(_ call: CAPPluginCall) {
        predictHandler.trackItem(call);
    }
    
    @objc func trackCategory(_ call: CAPPluginCall) {
        predictHandler.trackCategory(call);
    }
    
    @objc func trackSearch(_ call: CAPPluginCall) {
        predictHandler.trackSearch(call);
    }
    
    @objc func trackTag(_ call: CAPPluginCall) {
        predictHandler.trackTag(call);
    }
    
    @objc func trackCard(_ call: CAPPluginCall) {
        predictHandler.trackCard(call);
    }
    
    @objc func trackPurchase(_ call: CAPPluginCall) {
        predictHandler.trackPurchase(call);
    }
    
    // Custom Events
    
    @objc func trackCustomEvent(_ call: CAPPluginCall) {
        let eventAttributes = call.options["attributes"];
        
        Emarsys.trackCustomEvent(eventName: call.getString("name")!, eventAttributes: eventAttributes as? [String : String]) {
            error in
            guard error == nil else {
                call.reject(error!.localizedDescription)
                return
            }
            
            call.resolve();
        }
    }
    
    // Recommended Products
    
    @objc func recommendProducts(_ call: CAPPluginCall) {
        predictHandler.recommendProducts(call);
    }
    
    @objc func trackRecommendationClick(_ call: CAPPluginCall) {
        predictHandler.trackRecommendationClick(call);
    }
    
    // Inbox
    
    @objc func fetchMessages(_ call: CAPPluginCall) {
        inboxHandler.fetchMessages(call);
    }
    
    @objc func addTag(_ call: CAPPluginCall) {
        inboxHandler.addTag(call);
    }
    
    @objc func removeTag(_ call: CAPPluginCall) {
        inboxHandler.removeTag(call);
    }
    
    // Config
    
    @objc func getApplicationCode(_ call: CAPPluginCall) {
        configHandler.getApplicationCode(call);
    }
    
    @objc func setApplicationCode(_ call: CAPPluginCall) {
        configHandler.setApplicationCode(call);
    }
    
    @objc func getMerchantId(_ call: CAPPluginCall) {
        configHandler.getMerchantId(call);
    }
    
    @objc func setMerchantId(_ call: CAPPluginCall) {
        configHandler.setMerchantId(call);
    }
    
    @objc func getContactFieldId(_ call: CAPPluginCall) {
        configHandler.getContactFieldId(call);
    }
    
    @objc func getHardwareId(_ call: CAPPluginCall) {
        configHandler.getHardwareId(call);
    }
    
    @objc func getLanguageCode(_ call: CAPPluginCall) {
        configHandler.getLanguageCode(call);
    }
    
    @objc func getSdkVersion(_ call: CAPPluginCall) {
        configHandler.getSdkVersion(call);
    }
    
    // Helper
    
    private func sendMessage(eventName: String, payload: [String: Any]?) {
        let data: [String: Any] = ["eventName": eventName, "data": payload ?? []];
        self.send(eventName: "event", data: data);
    }
    
    private func sendSilentMessageInformation(block: EMSNotificationInformation) {
        let data: [String: Any] = ["campaignId": block.campaignId];
        self.send(eventName: "silentMessageInformation", data: data);
    }
    
    private func send(eventName: String, data: [String : Any]) {
        if(self.registered) {
            self.notifyListeners(eventName, data: data);
        } else {
            self.messageStack.append(StackedMessage(eventName: eventName, data: data));
        }
    }
    
    private func sendStacked() {
        if(self.messageStack.count > 0) {
            for message in self.messageStack {
                self.send(eventName: message.eventName, data: message.data);
            }
            self.messageStack.removeAll();        }
    }
}

enum PushNotificationsPermissions: String {
    case prompt
    case denied
    case granted
}
