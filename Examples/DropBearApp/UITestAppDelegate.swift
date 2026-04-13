import Foundation
import UIKit
import DropBearSupport

class UITestAppDelegate: AppDelegate {
    override func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
        config.delegateClass = UITestSceneDelegate.self
        return config
    }
}
