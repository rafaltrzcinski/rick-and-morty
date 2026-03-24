//
//  APIError.swift
//  RickyBuggyBright
//

import Foundation

struct APIError: Error {
    enum ErrorType {
        case imageDataRequestFailed
        case charactersRequestFailed
        case characterDetailRequestFailed
        case locationRequestFailed
    }
    
    let type: ErrorType
    let error: Error?
    
    init(type: ErrorType, error: Error? = nil) {
        self.type = type
        self.error = error
    }
}

extension APIError: LocalizedError {
    var localizedDescription: String {
        let mainError = switch self.type {
        case .imageDataRequestFailed: "Could not download image"
        case .charactersRequestFailed: "Could not fetch characters"
        case .characterDetailRequestFailed: "Could not get details of character"
        case .locationRequestFailed: "Could not get details of location"
        }
        
        return "\(mainError): \(self.error?.localizedDescription ?? "")"
    }
}
