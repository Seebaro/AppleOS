//
//  Entitlements.swift
//  Sibaro
//
//  Created by Emran on 11/4/23.
//

import Foundation

struct Entitlements: Codable {
    
    var applicationIdentifier: String
    var apsEnvironment: String
    var developerTeamID: String
    var getTaskAllow: Bool
    var keychainAccessGroups: [String]
    
    enum CodingKeys: String, CodingKey {
        case applicationIdentifier = "application-identifier"
        case apsEnvironment = "aps-environment"
        case developerTeamID = "com.apple.developer.team-identifier"
        case getTaskAllow = "get-task-allow"
        case keychainAccessGroups = "keychain-access-groups"
    }
    
    init(applicationIdentifier: String,
         apsEnvironment: String,
         developerTeamID: String,
         getTaskAllow: Bool,
         keychainAccessGroups: [String])
    {
        self.applicationIdentifier = applicationIdentifier
        self.apsEnvironment = apsEnvironment
        self.developerTeamID = developerTeamID
        self.getTaskAllow = getTaskAllow
        self.keychainAccessGroups = keychainAccessGroups
    }
        
    init(from plistURL: URL) throws {
        let plistData = try Data(contentsOf: plistURL)
        self = try PropertyListDecoder().decode(Entitlements.self, from: plistData)
    }
    
    func save(as plistName: String) throws {
        let saveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(plistName)
            .appendingPathExtension("plist")
        
        let encodedData = try PropertyListEncoder().encode(self)
        try encodedData.write(to: saveURL)
    }
 
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.applicationIdentifier = try container.decode(String.self, forKey: .applicationIdentifier)
        self.apsEnvironment = try container.decode(String.self, forKey: .apsEnvironment)
        self.developerTeamID = try container.decode(String.self, forKey: .developerTeamID)
        self.getTaskAllow = try container.decode(Bool.self, forKey: .getTaskAllow)
        self.keychainAccessGroups = try container.decode([String].self, forKey: .keychainAccessGroups)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.applicationIdentifier, forKey: .applicationIdentifier)
        try container.encode(self.apsEnvironment, forKey: .apsEnvironment)
        try container.encode(self.developerTeamID, forKey: .developerTeamID)
        try container.encode(self.getTaskAllow, forKey: .getTaskAllow)
        try container.encode(self.keychainAccessGroups, forKey: .keychainAccessGroups)
    }
}
