//
//  Date+FromString.swift
//  Sibaro
//
//  Created by Ebrahim Tahernejad on 5/23/1402 AP.
//

import Foundation

protocol AnyDateFormatter {
    func date(from: String) -> Date?
}


extension ISO8601DateFormatter: AnyDateFormatter {}
extension DateFormatter: AnyDateFormatter {}


extension Date {
    
    init?(from string: String) {
        let dateFormatter: AnyDateFormatter = {
            if string.count == 10 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter
            }
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return dateFormatter
        }()
        guard let date = dateFormatter.date(from: string) else {
            return nil
        }
        self = date
    }
    
}
