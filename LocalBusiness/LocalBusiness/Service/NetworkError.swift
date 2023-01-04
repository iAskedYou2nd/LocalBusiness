//
//  NetworkError.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/4/22.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badStatusCode(Int)
    case decodeFailure(Error)
    case other(Error)
}

extension NetworkError: LocalizedError {
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return NSLocalizedString("Invalid URL Used", comment: "Bad URL")
        case .badStatusCode(let code):
            return NSLocalizedString("Bad Server Response Code: \(code)", comment: "Bad Server Response Code")
        case .decodeFailure(let error):
            return NSLocalizedString("Decoding Failure for \(error)", comment: "Decode Failure")
        case .other(let error):
            return NSLocalizedString("Generic Error. Description: \(error)", comment: "Generic Error")
        }
    }
    
}
