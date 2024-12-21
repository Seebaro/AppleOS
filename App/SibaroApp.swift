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
    @StateObject var ipaFileManager: SBRIPAFileManager = SBRIPAFileManager()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(i18n)
                .environmentObject(ipaFileManager)
                .onOpenURL { url in
                    ipaFileManager.handleIncomingFile(url: url)
                }
        }
        #if os(macOS)
        .defaultSize(width: 1000, height: 650)
        #endif
    }
}
