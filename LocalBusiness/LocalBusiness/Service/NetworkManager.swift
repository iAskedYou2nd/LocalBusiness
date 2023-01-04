//
//  NetworkManager.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/4/22.
//

import Combine
import Foundation

protocol NetworkManagerType {
    func getModel<T: Decodable>(request: URLRequest?) -> AnyPublisher<T, NetworkError>
    func getRawData(request: URLRequest?) -> AnyPublisher<Data, NetworkError>
}

class NetworkManager {
    
    let session: URLSession
    let decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
    
}

extension NetworkManager: NetworkManagerType {
    
    func getModel<T: Decodable>(request: URLRequest?) -> AnyPublisher<T, NetworkError> {
        
        guard let request = request else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        
        return self.session.dataTaskPublisher(for: request)
            .tryMap { map in
                if let httpResponse = map.response as? HTTPURLResponse,
                   !(200..<300).contains(httpResponse.statusCode) {
                    throw NetworkError.badStatusCode(httpResponse.statusCode)
                }
                return map.data
            }.decode(type: T.self, decoder: self.decoder)
            .mapError { error in
                if let decodeError = error as? DecodingError {
                    return NetworkError.decodeFailure(decodeError)
                } else {
                    return NetworkError.other(error)
                }
            }.eraseToAnyPublisher()
        
    }
    
    func getRawData(request: URLRequest?) -> AnyPublisher<Data, NetworkError> {
        guard let request = request else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        
        return self.session.dataTaskPublisher(for: request)
            .tryMap { map in
                if let httpResponse = map.response as? HTTPURLResponse,
                   !(200..<300).contains(httpResponse.statusCode) {
                    throw NetworkError.badStatusCode(httpResponse.statusCode)
                }
                return map.data
            }.mapError { error in
                return NetworkError.other(error)
            }.eraseToAnyPublisher()
    }
    
}
