//
//  IPAUtilities.swift
//  Sibaro
//
//  Created by AminRa on 9/16/1403 AP.
//

import SwiftUI

struct IPAUtilities {
    static func extractAppIcon(from ipaUrl: URL, with fileManager: FileManager) -> Image? {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        do {
            try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
            try fileManager.unzipItem(at: ipaUrl, to: tempDir)
            
            guard let appBundle = try fileManager.contentsOfDirectory(at: tempDir.appendingPathComponent("Payload"), includingPropertiesForKeys: nil).first(where: { $0.pathExtension == "app" }) else {
                return nil
            }
            
            let appIconFiles = try fileManager.contentsOfDirectory(at: appBundle, includingPropertiesForKeys: nil)
                .filter { $0.lastPathComponent.contains("AppIcon") && $0.pathExtension == "png" }
            
            if let bestIcon = appIconFiles.sorted(by: { $0.lastPathComponent.count > $1.lastPathComponent.count }).first {
                return Image(uiImage: UIImage(contentsOfFile: bestIcon.path) ?? UIImage())
            }
        } catch {
            print("Error extracting app icon: \(error)")
        }
        
        try? fileManager.removeItem(at: tempDir)
        return nil
    }
    
    static func ipa(from url: URL, with fileManager: FileManager) -> IPAFile? {
        let appIcon = IPAUtilities.extractAppIcon(from: url, with: fileManager)
        let ipaFile = IPAFile(name: url.deletingPathExtension().lastPathComponent, fileUrl: url, appIcon: appIcon)
        return ipaFile
    }
    
    static func extractInformation(from url: URL, with fileManager: FileManager) -> IPAInformation? {
        let tempDir = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        do {
            try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
            try fileManager.unzipItem(at: url, to: tempDir)
            
            guard let appBundle = try fileManager.contentsOfDirectory(at: tempDir.appendingPathComponent("Payload"), includingPropertiesForKeys: nil).first(where: { $0.pathExtension == "app" }) else {
                print("App bundle not found.")
                return nil
            }
            
            let infoPlistURL = appBundle.appendingPathComponent("Info.plist")
            let plistData = try Data(contentsOf: infoPlistURL)
            guard let plist = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] else {
                print("Failed to parse Info.plist.")
                return nil
            }
            
            let name = plist["CFBundleName"] as? String ?? "Unknown"
            let bundleIdentifier = plist["CFBundleIdentifier"] as? String ?? "Unknown"
            let version = plist["CFBundleShortVersionString"] as? String ?? "Unknown"
            let build = plist["CFBundleVersion"] as? String ?? "Unknown"
            let minimumOSVersion = plist["MinimumOSVersion"] as? String ?? "Unknown"
            let deviceFamily = (plist["UIDeviceFamily"] as? [Int])?.map {
                $0 == 1 ? "iPhone" : "iPad"
            } ?? []
            
            let supportedLanguages = try fileManager.contentsOfDirectory(at: appBundle, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "lproj" }
                .map { $0.deletingPathExtension().lastPathComponent }
            
            let entitlements = extractEntitlements(from: appBundle.appendingPathComponent("embedded.mobileprovision"))
            
            return IPAInformation(
                name: name,
                bundleIdentifier: bundleIdentifier,
                version: version,
                build: build,
                minimumOSVersion: minimumOSVersion,
                deviceFamily: deviceFamily,
                entitlements: entitlements,
                supportedLanguages: supportedLanguages
            )
        } catch {
            print("Error extracting IPA: \(error)")
        }
        
        try? fileManager.removeItem(at: tempDir)
        return nil
    }
    
    static func extractEntitlements(from provisioningURL: URL) -> [String: Any]? {
        guard let provisioningData = try? Data(contentsOf: provisioningURL),
              let provisioningContent = String(data: provisioningData, encoding: .utf8) else {
            return nil
        }
        
        let plistStart = provisioningContent.range(of: "<?xml")?.lowerBound
        let plistEnd = provisioningContent.range(of: "</plist>")?.upperBound
        guard let start = plistStart, let end = plistEnd else { return nil }
        
        let plistString = provisioningContent[start..<end]
        guard let plistData = plistString.data(using: .utf8),
              let plist = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] else {
            return nil
        }
        
        return plist["Entitlements"] as? [String: Any]
    }
    
}

struct IPAInformation {
    let name: String
    let bundleIdentifier: String
    let version: String
    let build: String
    let minimumOSVersion: String
    let deviceFamily: [String]
    let entitlements: [String: Any]?
    let supportedLanguages: [String]
}

extension IPAInformation {
    static var unknown: IPAInformation {
        .init(
            name: "Unknown",
            bundleIdentifier: "Unknown",
            version: "Unknown",
            build: "Unknown",
            minimumOSVersion: "Unknown",
            deviceFamily: [],
            entitlements: nil,
            supportedLanguages: []
        )
    }
}

