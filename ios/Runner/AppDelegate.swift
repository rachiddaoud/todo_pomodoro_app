import UIKit
import Flutter
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Request notification permission
    requestNotificationPermission()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Function to request notification permission
  func requestNotificationPermission() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        // Handle the error if permission is not granted
        print("Notification permission error: \(error)")
      } else if granted {
        print("Notification permission granted")
      } else {
        print("Notification permission denied")
      }
    }

    // Set the UNUserNotificationCenter's delegate
    center.delegate = self
  }

  // Optional: Handle notification display when the app is in the foreground
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.alert, .sound])  // Show alerts and play sound while the app is in the foreground
  }
}