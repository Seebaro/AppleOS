//
//  DocumnetPicker.swift
//  Sibaro
//
//  Created by AminRa on 9/15/1403 AP.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    let completion: (Result<URL, Error>) -> Void
    let fileTypes: [UTType] = [.init(filenameExtension: "ipa")!]
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: fileTypes)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let completion: (Result<URL, Error>) -> Void
        
        init(completion: @escaping (Result<URL, Error>) -> Void) {
            self.completion = completion
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                completion(.failure(NSError(domain: "No file selected.", code: 0, userInfo: nil)))
                return
            }
            completion(.success(url))
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            completion(.failure(NSError(domain: "User cancelled file selection.", code: 0, userInfo: nil)))
        }
    }
}

