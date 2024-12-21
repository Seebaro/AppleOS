//
//  IpaFile.swift
//  Sibaro
//
//  Created by AminRa on 9/16/1403 AP.
//

import SwiftUI

struct IPAFile: Identifiable {
    let id = UUID()
    let name: String
    let fileUrl: URL
    let appIcon: Image?
    
    init (name: String, fileUrl: URL, appIcon: Image? = nil) {
        self.name = name
        self.fileUrl = fileUrl
        self.appIcon = appIcon
    }
}
