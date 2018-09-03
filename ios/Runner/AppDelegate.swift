import UIKit
import Flutter
import Firebase
import GoogleMobileAds

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {

    // Use Firebase library to configure APIs.
    FirebaseApp.configure()

    // Initialize the Google Mobile Ads SDK.
    GADMobileAds.configure(withApplicationID: "ca-app-pub-4642980268605791~9598994286")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
