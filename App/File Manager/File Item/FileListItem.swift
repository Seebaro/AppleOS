//
//  FileListItem.swift
//  Sibaro
//
//  Created by AminRa on 9/15/1403 AP.
//

import SwiftUI

struct FileListItem: View {
    let ipaFile: IPAFile
    
    var body: some View {
        HStack {
            (ipaFile.appIcon ?? Image(systemName: "doc.circle"))
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(ipaFile.name)
                .font(.headline)
                .padding(.leading, 10)
        }
    }
}
