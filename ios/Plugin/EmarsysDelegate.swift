import Foundation;
import UIKit;

open class EmarsysDelegate: UIResponder, UIApplicationDelegate {
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotificationCenter.default.post(name: .emarsysRegisterWithToken, object: deviceToken);
     }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      NotificationCenter.default.post(name: .emarsysRegisterFailed, object: error)
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NotificationCenter.default.post(name: .emarsysReceivedRemoteNotification, object: completionHandler, userInfo: userInfo)
    }
}
