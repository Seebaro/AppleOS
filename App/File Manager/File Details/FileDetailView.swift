import SwiftUI

struct FileDetailView: View {
    let ipa: IPAFile
    let ipaInfo: IPAInformation
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            
            VStack(spacing: 16) {
                if let appIcon = ipa.appIcon {
                    appIcon
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                } else {
                    Image(systemName: "app.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                }

                Text(ipaInfo.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 20)

            
            HStack(spacing: 20) {
                Button(action: signIPA) {
                    Label("Sign", systemImage: "pencil")
                }
                
                Button(action: installIPA) {
                    Label("Install", systemImage: "arrow.down.circle")
                }
            }
            .buttonStyle(.bordered)
            .padding()

            Divider()
                .padding(.horizontal)

            
            List {
                Section(header: Text("App Details").font(.headline)) {
                    DetailRow(label: "Bundle Identifier", value: ipaInfo.bundleIdentifier)
                    DetailRow(label: "Version", value: ipaInfo.version)
                    DetailRow(label: "Build", value: ipaInfo.build)
                    DetailRow(label: "Minimum OS Version", value: ipaInfo.minimumOSVersion)
                    DetailRow(label: "Device Family", value: ipaInfo.deviceFamily.joined(separator: ", "))
                }

                if let entitlements = ipaInfo.entitlements, !entitlements.isEmpty {
                    Section(header: Text("Entitlements").font(.headline)) {
                        ForEach(entitlements.keys.sorted(), id: \.self) { key in
                            DetailRow(label: key, value: "\(entitlements[key] ?? "N/A")")
                        }
                    }
                }

                if !ipaInfo.supportedLanguages.isEmpty {
                    Section(header: Text("Supported Languages").font(.headline)) {
                        ForEach(ipaInfo.supportedLanguages, id: \.self) { language in
                            Text(language.capitalized)
                                .foregroundColor(.primary)
                                .padding(.vertical, 2)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("IPA Information")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    shareIPA()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }

    private func shareIPA() {
        let ipaURL = ipa.fileUrl
        let activityVC = UIActivityViewController(activityItems: [ipaURL], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true)
        }
    }

    private func signIPA() {
        print("Sign button tapped")
    }

    private func installIPA() {
        print("Install button tapped")
    }
}

extension FileDetailView {
    struct DetailRow: View {
        let label: String
        let value: String

        var body: some View {
            HStack {
                Text(label)
                    .font(.body)
                    .foregroundColor(.secondary)
                Spacer()
                Text(value)
                    .font(.body)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 4)
        }
    }
}
