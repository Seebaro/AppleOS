//
//  Bundle.swift
//  Sibaro
//
//  Created by Emran on 11/4/23.
//

import Foundation

public extension Bundle {
    
    func info(for key: String) -> String! {
        guard let value = infoDictionary?[key] else { return nil }
        return (value as! String).replacingOccurrences(of: "\\", with: "")
    }
}
