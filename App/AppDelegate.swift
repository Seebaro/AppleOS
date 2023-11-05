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
        guard let sentryDSN else { return }
        SentrySDK.start { options in
            options.dsn = sentryDSN
            options.debug = isDebug // Enabled debug when first installing is always helpful
            options.environment = isDebug ? "DEVELOPMENT" : "PRODUCTION"
            options.diagnosticLevel = isDebug ? .debug : .error
            options.tracesSampleRate = 1.0
            options.profilesSampleRate = 1.0
            options.dist = "@c"
            options.attachScreenshot = true
            options.attachViewHierarchy = true
            options.enableCrashHandler = true
            options.enableTracing = true
            options.enablePreWarmedAppStartTracing = true
            options.enableCaptureFailedRequests = true
            options.enableTimeToFullDisplayTracing = true
            options.swiftAsyncStacktraces = true
            options.enableMetricKit = true
        }
    }
    
    private func setupPushNotification(_ launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        #if DEBUG
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        #endif
        guard let oneSignalAppID else { return }
        OneSignal.initialize(oneSignalAppID, withLaunchOptions: launchOptions)
        
        // requestPermission will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)
    }
}
