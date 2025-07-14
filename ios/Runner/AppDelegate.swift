import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging

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
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
      print("📲 APNs Token: \(deviceToken)")
      super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
