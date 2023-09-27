//
//  StorageService.swift
//  Sibaro
//
//  Created by Ebrahim Tahernejad on 5/23/1402 AP.
//

import Foundation

protocol StorageServicable: BaseService {
    var token: String? { get set }
    var username: String? { get set }
    var publicKey: String? { get set }
    var privateKey: String? { get set }
    func logout()
    
    var language: Language { get set }
}

class StorageService: BaseService, StorageServicable {
    // MARK: - UserInfo
    @Stored(key: "Sibaro.Token", in: .keychain) var token: String? = nil
    @Stored(key: "Sibaro.Username") var username: String? = nil
    @Stored(key: "Sibaro.PublicKey", in: .keychain) var publicKey: String? = nil
    @Stored(key: "Sibaro.PrivateKey", in: .keychain) var privateKey: String? = nil
    
    func logout() {
        token = nil
        username = nil
    }
    
    // MARK: - Language
    @Stored(key: "Sibaro.Language") var language: Language = .en
}
