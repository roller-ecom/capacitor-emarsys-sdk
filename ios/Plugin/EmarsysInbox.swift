import Foundation
import Capacitor
import EmarsysSDK

public class EmarsysInbox {
    public func fetchMessages(_ call: CAPPluginCall) {
        Emarsys.messageInbox.fetchMessages { inboxResult, error in
            guard error == nil else {
                call.reject(error!.localizedDescription)
                return
            }
            
            call.resolve(self.formatMessages(messages: inboxResult!.messages));
        }
    }
    
    public func addTag(_ call: CAPPluginCall) {
        Emarsys.messageInbox.addTag(tag: call.getString("tag")!, messageId: call.getString("messageId")!) { error in
            guard error == nil else {
                call.reject(error!.localizedDescription)
                return
            }
            
            call.resolve();
        }
    }
    
    public func removeTag(_ call: CAPPluginCall) {
        Emarsys.messageInbox.removeTag(tag: call.getString("tag")!, messageId: call.getString("messageId")!) { error in
            guard error == nil else {
                call.reject(error!.localizedDescription)
                return
            }
            
            call.resolve();
        }
    }
    
    // Helper
    
    private func formatMessages(messages: [EMSMessage]?) -> PluginCallResultData {
        var jsMessages = [JSObject]();
        
        messages?.forEach { message in
            var jsMessage = JSObject.init(dictionaryLiteral:
                                            ("id", message.id),
                                          ("campaignId", message.campaignId),
                                          ("title", message.title),
                                          ("body", message.body),
                                          ("receivedAt", message.receivedAt.intValue)
            );
            
            if(message.collapseId != nil) {
                jsMessage["collapseId"] = message.collapseId;
            }
            
            if(message.imageUrl != nil) {
                jsMessage["imageUrl"] = message.imageUrl;
            }
            
            if(message.updatedAt != nil) {
                jsMessage["updatedAt"] = message.updatedAt!.intValue;
            }
            
            if(message.expiresAt != nil) {
                jsMessage["expiresAt"] = message.expiresAt!.intValue;
            }
            
            var jsMessageTags = JSArray();
            message.tags?.forEach { tag in
                jsMessageTags.append(tag);
            }
            jsMessage["tags"] = jsMessageTags;
            
            jsMessage["properties"] = JSTypes.coerceDictionaryToJSObject(message.properties ?? [:] )!
            
            jsMessage["actions"] = self.formatMessageActions(actions: message.actions)
            
            jsMessages.append(jsMessage);
        }
        
        return ["messages": jsMessages];
    }
    
    private func formatMessageActions(actions: [EMSActionModelProtocol]?) -> JSValue {
        var jsActions = [JSObject]();
        
        actions?.forEach { action in
            var jsAction = JSObject.init(dictionaryLiteral:
                                            ("id", action.id()),
                                         ("title", action.title()),
                                         ("type", action.type())
            );
            
            if let applicationAction = action as? EMSAppEventActionModel {
                jsAction["name"] = applicationAction.name;
                jsAction["payload"] = JSTypes.coerceDictionaryToJSObject(applicationAction.payload ?? [:] )!;
            } else if let customAction = action as? EMSCustomEventActionModel {
                jsAction["name"] = customAction.name;
                jsAction["payload"] = JSTypes.coerceDictionaryToJSObject(customAction.payload ?? [:] )!;
            } else if let externalUrlAction = action as? EMSOpenExternalUrlActionModel {
                jsAction["url"] = externalUrlAction.url.absoluteString;
            }
            
            jsActions.append(jsAction);
        }
        
        return jsActions;
    }
}
