//
//  RequestError.swift
//  Sibaro
//
//  Created by Armin on 2/19/22.
//

import Foundation

public enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case badRequest(Data)
    case unauthorized(Data)
    case unexpectedStatusCode(Int)
    case needsUpdate
    case unknown(String)
}

extension RequestError: LocalizedError {
    public var description: String {
        switch self {
        case .decode:
            return NSLocalizedString("Parsing error", comment: "")
        case .invalidURL:
            return NSLocalizedString("Network error", comment: "Invalid URL")
        case .noResponse:
            return NSLocalizedString("Network error", comment: "no response")
        case .badRequest:
            return NSLocalizedString("Bad Request", comment: "")
        case .unauthorized:
            return NSLocalizedString("Session expired", comment: "no response")
        case .unexpectedStatusCode(let status):
            return NSLocalizedString("Unexpected Status Code \(status) occured", comment: "")
        case .needsUpdate:
            return NSLocalizedString("Needs Update", comment: "")
        case .unknown(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}

extension RequestError: Identifiable {
    public var id: String? {
        errorDescription
    }
}
