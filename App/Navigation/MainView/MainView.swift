//
//  MainView.swift
//  Sibaro
//
//  Created by Armin on 8/13/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) private var dismiss
    @Injected(\.openURL) var openURL
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            loading
        case .main, .login:
            mainBody
        case .error(let error):
            self.error(error)
        }
    }

    @ViewBuilder var mainBody: some View {
        ZStack {
            if viewModel.forceUpdate {
                forceUpdateView
            } else if viewModel.isAuthenticated {
                #if os(iOS)
                if horizontalSizeClass == .compact {
                    TabNavigation()
                } else {
                    Sidebar()
                }
                #else
                Sidebar()
                #endif
            } else {
                LoginView()
            }
        }
        .alert(
            viewModel.i18n.UpdateAlert_Title,
            isPresented: $viewModel.optionalUpdate
        ) {
            Button(viewModel.i18n.UpdateAlert_Cancel, role: .cancel) {
                dismiss()
            }
            Button(viewModel.i18n.UpdateAlert_Confirm) {
                viewModel.updateApplication()
            }
        } message: {
            Text(viewModel.i18n.UpdateAlert_Body)
        }
    }
    
    @ViewBuilder var forceUpdateView: some View {
        VStack(spacing: 35) {
            Spacer()
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 110, height: 110)
                .cornerRadius(15)
            Text(viewModel.i18n.ForceUpdate_Title)
                .font(.largeTitle)
            Text(viewModel.i18n.ForceUpdate_Body)
            Spacer()
            Button {
                viewModel.updateApplication()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill()
                        .foregroundStyle(Color.accentColor)
                    Text(viewModel.i18n.ForceUpdate_Update)
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder var main: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            TabNavigation()
        } else {
            Sidebar()
        }
        #else
        Sidebar()
        #endif
    }
    
    var loading: some View {
        Text("Loading")
    }
    
    func error(_ error: Error) -> some View {
        Text("Error")
    }
}


struct MainView_Previews: PreviewProvider {
    @ObservedObject static var i18n = I18nService()
    
    static var previews: some View {
        MainView()
            .environmentObject(i18n)
    }
}
