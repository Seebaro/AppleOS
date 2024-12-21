//
//  IPAFileManager.swift
//  Sibaro
//
//  Created by AminRa on 9/22/1403 AP.
//

import Foundation

protocol IPAFileManager {
    var fileManager: FileManager { set get }
    func handleIncomingFile(url: URL)
    func loadIPAFiles() -> [IPAFile]
    func deleteIPA(_ ipa: IPAFile) throws
    func saveIPA(fromSource fileURL: URL) throws(IPAFileError) -> IPAFile
}

enum IPAFileError: String, Error {
    case fileExists = "File already exists"
    case destinationDirectoryNotAvailable = "Destination directory not available"
    case ipaFileNotAvailable = "IPA file not available"
    case unknownError = "Unknown error"
}

class SBRIPAFileManager: IPAFileManager, ObservableObject {
    
    @Injected(\.fileManager) var fileManager
    @Injected(\.notificationCenter) var notificationCenter
    
    private var documentsDirectory: URL? {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func handleIncomingFile(url: URL) {
        guard let documentsDirectory  else {
            print("Failed to locate documents directory.")
            return
        }
        
        let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        do {
            try fileManager.copyItem(at: url, to: destinationURL)
            notificationCenter.post(name: .onNewIpaAdded, object: destinationURL)
        } catch {
            print("Error handling incoming file: \(error)")
        }
    }
    
    func loadIPAFiles() -> [IPAFile] {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let files = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
                return files
                    .filter { $0.pathExtension == "ipa" }
                    .map { IPAFile(name: $0.deletingPathExtension().lastPathComponent, fileUrl: $0, appIcon: IPAUtilities.extractAppIcon(from: $0, with: fileManager)) }
            } catch {
                print("Error loading IPA files: \(error)")
                return []
            }
        }
        return []
    }
    
    func deleteIPA(_ ipa: IPAFile) throws {
        do {
            try fileManager.removeItem(at: ipa.fileUrl)
        } catch {
            throw error
        }
    }
    
    func saveIPA(fromSource fileURL: URL) throws(IPAFileError) -> IPAFile {
        guard let documentsDirectory else {
            throw .destinationDirectoryNotAvailable
        }
        let destinationURL = documentsDirectory.appendingPathComponent(fileURL.lastPathComponent)
        if fileManager.fileExists(atPath: destinationURL.path) {
            throw .fileExists
        }
        
        do {
            try fileManager.copyItem(at: fileURL, to: destinationURL)
            if let ipaFile = IPAUtilities.ipa(from: destinationURL, with: fileManager) {
                return ipaFile
            } else {
                throw IPAFileError.ipaFileNotAvailable
            }
        } catch let err {
            print("Error while trying to load file: \(err.localizedDescription)")
            throw .unknownError
        }
    }
}
