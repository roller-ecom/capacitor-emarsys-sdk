import Foundation

// swiftlint:disable identifier_name
extension Notification.Name {
    public static let emarsysRegisterWithToken = Notification.Name(rawValue: "EmarsysRegisterWithToken")
    public static let emarsysRegisterFailed = Notification.Name(rawValue: "EmarsysRegisterFailed")
    public static let emarsysReceivedRemoteNotification = Notification.Name(rawValue: "EmarsysReceivedRemoteNotification")
}

class StackedMessage {
    var eventName: String
    var data: [String : Any]
    
    init (eventName: String, data: [String : Any]) {
        self.eventName = eventName;
        self.data = data;
    }
}
