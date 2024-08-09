//
//  ProductViewModel.swift
//  Sibaro
//
//  Created by Ebrahim Tahernejad on 5/25/1402 AP.
//

import Foundation
import Toast

extension ProductItemView {
    @MainActor
    class ViewModel: BaseViewModel {
        @Injected(\.applications) var applications
        @Injected(\.productRepository) var productRepository
        @Injected(\.openURL) var openURL
        
        @Published var loading: Bool = false
        
        var product: Product
        
        var appState: InstallationState {
            applications.getAppState(product)
        }
        
        init(product: Product) {
            self.product = product
        }
        
        @discardableResult private func install() async throws -> Bool {
            let manifest = try await productRepository.getManifest(
                id: product.id
            )
            if let manifest {
                let _ = openURL(manifest)
            }
            return manifest != nil
        }
        
        private func _handleApplicationAction() async {
            loading = true
            do {
                switch appState {
                case .open :
                    applications.openApplication(product.bundleIdentifier)
                default :
                    let num_retries = 6
                    for i in 0..<num_retries {
                        let gotManifest = try await install()
                        if gotManifest {
                            break
                        } else if i == num_retries - 1 {
                            let toast = Toast.text("در حال آماده‌سازی اپلیکیشن", subtitle:"لطفا چند دقیقه دیگه تلاش کنید")
                            toast.show()
                            break
                        } else {
                            try await Task.sleep(nanoseconds: UInt64(5_000_000_000))
                        }
                    }
                }
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            loading = false
        }
        
        nonisolated func handleApplicationAction() {
            Task {
                await _handleApplicationAction()
            }
        }
    }
}
