//
//  AppDelegate.swift
//  Sibaro
//
//  Created by Emran Novin on 10/20/23.
//

import SwiftUI
import Sentry

import OneSignalFramework

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupLogger()
        setupPushNotification(launchOptions)
        return true
    }
    
    private func setupLogger() {
        SentrySDK.start { options in
            options.dsn = sentryDSN
            options.debug = isDebug // Enabled debug when first installing is always helpful
            options.enableTracing = true

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
        }
        // Remove the next line after confirming that your Sentry integration is working.
        SentrySDK.capture(message: "This app uses Sentry! :)")
    }
    
    private func setupPushNotification(_ launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        // Remove this method to stop OneSignal Debugging
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        
        // OneSignal initialization
        OneSignal.initialize(oneSignalAppID, withLaunchOptions: launchOptions)
        
        // requestPermission will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)
        
        // Login your customer with externalId
        // OneSignal.login("EXTERNAL_ID")
    }
}
