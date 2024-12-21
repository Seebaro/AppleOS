//
//  Panel.swift
//  Sibaro
//
//  Created by Armin on 8/13/23.
//

import SwiftUI

enum Panel: CaseIterable {
    case apps
    case games
    case profile
    case files
    
    var title: String {
        switch self {
        case .apps:
            return "Apps"
        case .games:
            return "Games"
        case .profile:
            return "Profile"
        case .files:
            return "Files"
        }
    }
    
    var icon: String {
        switch self {
        case .apps:
            return "square.stack.3d.up"
        case .games:
            return "gamecontroller"
        case .profile:
            return "person.crop.circle"
        case .files:
            return "folder"
        }
    }
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .apps:
            ProductsListView(type: .app)
        case .games:
            ProductsListView(type: .game)
        case .profile:
            ProfileView()
        case .files:
            FileManagerView()
        }
    }
}
