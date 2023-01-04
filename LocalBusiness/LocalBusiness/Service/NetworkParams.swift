//
//  NetworkParams.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/4/22.
//

import Foundation

enum NetworkParams {
    
    private struct NetworkConstants {
        static let rootPath = "https://api.yelp.com/v3/"
        static let search = "businesses/search"
        static let authorization = "Bearer OyFRR5PRd5I5hJ1f1ihFkqyANxelEJi0L6T06z3OvrthiWSan7_0ZZSZ_IhganUVxsCMwcxA-qmCeJJGkcyN-zW5CMWm-IVlyc0JZx2Ya92MU6Smr9OTuHuoy2EzY3Yx"
    }
    
    private enum NetworkRequestType: String {
        case get = "GET"
        case post = "POST"
    }
    
    // TODO: Consider allow for ways to select different categories
    case nearbyBusinessSearch(lat: Double, long: Double)
    case businessReviews(id: String)
    
    
    var urlRequest: URLRequest? {
        switch self {
        case .nearbyBusinessSearch(let lat, let long):
            var urlComponents = URLComponents(string: NetworkConstants.rootPath + NetworkConstants.search)
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "latitude", value: "\(lat)"))
            queryItems.append(URLQueryItem(name: "longitude", value: "\(long)"))
            queryItems.append(URLQueryItem(name: "categories", value: "restaurants"))
            urlComponents?.queryItems = queryItems
            
            return applyAuthorization(url: urlComponents?.url)
        case .businessReviews(let id):
            let url = URL(string: NetworkConstants.rootPath + "businesses/\(id)/reviews")
            return self.applyAuthorization(url: url)            
        }
    }
    
    private func applyAuthorization(url: URL?) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = NetworkRequestType.get.rawValue
        request.setValue(NetworkConstants.authorization, forHTTPHeaderField: "Authorization")
        return request
    }
    
    
}
