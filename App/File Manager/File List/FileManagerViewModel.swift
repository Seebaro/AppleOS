//
//  FileManagerViewModel.swift
//  Sibaro
//
//  Created by AminRa on 9/4/1403 AP.
//

import Foundation
import Combine

extension FileManagerView {
    class ViewModel: BaseViewModel {
        
        private var currentDirectory: URL
        @Published var files: [IPAFile] = []
        @Injected(\.ipaFileManager) var ipaFileManager
        @Injected(\.notificationCenter) var notificationCenter
        
        var alertSubject: PassthroughSubject<String, Never> = PassthroughSubject()
        
        init(currentDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!) {
            self.currentDirectory = currentDirectory
            super.init()
            loadFiles()
            notificationCenter.addObserver(forName: .onNewIpaAdded, object: nil, queue: nil) { [weak self] notif in
                if let url = notif.object as? URL {
                    self?.saveFileToCurrentDirectory(fileURL: url)
                }
            }
        }
        
        deinit {
            notificationCenter.removeObserver(self, name: .onNewIpaAdded, object: nil)
        }
        
        
        private func loadFiles() {
            self.files = ipaFileManager.loadIPAFiles()
        }
        
        func saveFileToCurrentDirectory(fileURL: URL) {
            do {
                let ipaFile = try ipaFileManager.saveIPA(fromSource: fileURL)
                self.files.append(ipaFile)
            } catch let err {
                alertSubject.send(err.rawValue)
            }
            
        }
        
        private func filterAndSort() {
            
        }
        
        func deleteIPA(_ ipa: IPAFile) {
            do {
                try ipaFileManager.deleteIPA(ipa)
                files.removeAll { $0.id == ipa.id }
            } catch {
                alertSubject.send("Error deleting IPA file: \(error)")
            }
        }
        
        func signIPA(_ ipa: IPAFile) {
            //TODO: Sign IPA
        }
        
        func installIPA(_ ipa: IPAFile) {
            //TODO: Install IPA
        }
        
        func getIPAInformation(_ ipaFile: IPAFile) -> IPAInformation {
            IPAUtilities.extractInformation(from: ipaFile.fileUrl, with: ipaFileManager.fileManager) ?? .unknown
        }
    }
}
