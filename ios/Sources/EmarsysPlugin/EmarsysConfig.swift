import Foundation
import Capacitor
import EmarsysSDK

public class EmarsysConfig {
    public func getApplicationCode(_ call: CAPPluginCall) {
        call.resolve(["applicationCode": Emarsys.config.applicationCode()]);
    }
    
    public func setApplicationCode(_ call: CAPPluginCall) {
        Emarsys.config.changeApplicationCode(applicationCode: call.getString("applicationCode")!) { error in
            guard error == nil else {
                call.reject(error!.localizedDescription)
                return
            }
            
            call.resolve();
        }
    }
    
    public func getMerchantId(_ call: CAPPluginCall) {
        call.resolve(["merchantId": Emarsys.config.merchantId()]);
    }
    
    public func setMerchantId(_ call: CAPPluginCall) {
        Emarsys.config.changeMerchantId(merchantId: call.getString("merchantId")!) { error in
            guard error == nil else {
                call.reject(error!.localizedDescription)
                return
            }
            
            call.resolve();
        }
    }
    
    public func getContactFieldId(_ call: CAPPluginCall) {
        call.resolve(["contactFieldId": Emarsys.config.contactFieldId().intValue]);
    }
    
    public func getHardwareId(_ call: CAPPluginCall) {
        call.resolve(["hardwareId": Emarsys.config.hardwareId()]);
    }
    
    public func getLanguageCode(_ call: CAPPluginCall) {
        call.resolve(["languageCode": Emarsys.config.languageCode()]);
    }
    
    public func getSdkVersion(_ call: CAPPluginCall) {
        call.resolve(["sdkVersion": Emarsys.config.sdkVersion()]);
    }
}
