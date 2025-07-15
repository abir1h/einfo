import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import app_links

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()

      // ✅ Set FCM delegate for foreground message handling
      UNUserNotificationCenter.current().delegate = self

      // ✅ Register for remote notifications
      application.registerForRemoteNotifications()

      GeneratedPluginRegistrant.register(with: self)
       if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
            // We have a link, propagate it to your Flutter app or not
            AppLinks.shared.handleLink(url: url)
            return true // Returning true will stop the propagation to other packages
          }
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
      print("📲 APNs Token: \(deviceToken)")
      super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
