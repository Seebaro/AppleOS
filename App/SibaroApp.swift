//
//  SibaroApp.swift
//  Sibaro
//
//  Created by Armin on 8/13/23.
//

import SwiftUI

@main
struct SibaroApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var i18n: I18nService = I18nService()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(i18n)
        }
        #if os(macOS)
        .defaultSize(width: 1000, height: 650)
        #endif
    }
}
