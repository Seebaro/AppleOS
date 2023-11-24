//
//  ProfileViewModel.swift
//  Sibaro
//
//  Created by AminRa on 5/25/1402 AP.
//

import Foundation
import OneSignalFramework

extension ProfileView {
    class ViewModel: BaseViewModel {
        @Injected(\.storage) private var storage
        
        @Published var showAppSuggestion: Bool = false
        @Published var showChangePass: Bool = false
        @Published var showLogoutDialog: Bool = false

        var userName: String {
            return storage.username ?? ""
        }
        
        
        private func _logout() async {
            OneSignal.logout()
            storage.logout()
        }
        
        func logout() {
            Task {
                await _logout()
            }
        }
    }
}
