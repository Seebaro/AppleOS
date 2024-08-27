//
//  LoginView.swift
//  Sibaro
//
//  Created by Armin on 8/13/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @FocusState private var focusedField: LoginField?
    
    private enum LoginField: Hashable {
        case username, password
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                content
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
            }
            .clipped()
        }
        
        #if os(macOS)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            VisualEffectBlur(state: .active)
                .edgesIgnoringSafeArea(.all)
        }
        #endif
    }
    
    var content: some View {
        VStack {
            Spacer()
            
            // MARK: - App Logo
            Image("iTroyPure")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.primary)
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 150)
                .shadow(radius: 2)
            
            VStack {
                // MARK: - Fields
                VStack(alignment: .leading) {
                    Label {
                        // MARK: - Username Field
                        TextField("Username", text: $viewModel.username)
                            .textContentType(.username)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .username)
                            .disabled(viewModel.loading)
                            .padding()
                            .disableAutocorrection(true)
                            #if os(iOS)
                            .autocapitalization(.none)
                            #endif
                            .onSubmit {
                                focusedField = .password
                            }
                    } icon: {
                        Image(systemName: "at")
                    }
                    
                    Label {
                        // MARK: - Password Field
                        SecureField("Password", text: $viewModel.password)
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .privacySensitive(true)
                            .submitLabel(.done)
                            .disabled(viewModel.loading)
                            .padding()
                            .onSubmit(viewModel.login)
                    } icon: {
                        Image(systemName: "lock")
                    }
                }
                .textFieldStyle(.plain)
                .padding(.horizontal)
                .background(
                    .regularMaterial,
                    in: RoundedRectangle(cornerRadius: 10)
                )
                
                // MARK: - Login button
                ZStack {
                    Button(action: viewModel.login) {
                        Text(viewModel.loading ? "" : "Login")
                            .font(.body)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical)
                    .disabled(viewModel.isNotSubmittable)

                    // MARK: ProgressView
                    if viewModel.loading {
                        ProgressView()
                    }
                }
                
                // MARK: - Response message
                Text(viewModel.message)
                    .font(.callout)
                    .foregroundColor(.red)
            }
            .frame(maxWidth: 300)
            
            Spacer()
        }
        .padding()
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
