//
//  MainViewModel.swift
//  Sibaro
//
//  Created by Ebrahim Tahernejad on 5/25/1402 AP.
//
import Combine

extension MainView {
    class ViewModel: BaseViewModel {
        @Injected(\.storage) var storage
        @Injected(\.update) var update
        @Published var forceUpdate: Bool = false
        @Published var optionalUpdate: Bool = false
        
        override init() {
            super.init()
            update.updateSubject.filter { $0 }.map { _ in true }.assign(to: &$forceUpdate)
            update.updateSubject.filter { !$0 }.map { _ in true }.assign(to: &$optionalUpdate)
            update.updateSubject.sink { forceUpdate in
                print("forceUpdate: \(forceUpdate)")
            }.store(in: &cancelBag)
        }
        
        var isAuthenticated: Bool {
            storage.token != nil
        }
        
        func updateApplication() {
            update.update()
        }
    }
}
