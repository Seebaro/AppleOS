//
//  ProductsEndpoint.swift
//  Sibaro
//
//  Created by Armin on 8/13/23.
//

import Foundation

enum ProductsEndpoint {
    case applications
    case appManifest(id: Int)
}

extension ProductsEndpoint: Endpoint {
    var path: String {
        switch self {
        case .applications:
            return "/api/applications/"
        case .appManifest(let id):
            return "/api/applications/\(id)/sign/"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var needsToken: Bool {
        switch self {
        case .applications,
             .appManifest:
            return true
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .applications,
             .appManifest:
            return [
                "Content-Type" : "application/json; charset=utf-8"
            ]
        }
        
    }
    
    var urlParams: [URLQueryItem]? {
        return nil
    }
    
    var body: [String : Any]? {
        return nil
    }
}
