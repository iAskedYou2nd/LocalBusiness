//
//  Business.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/4/22.
//

import Foundation

struct Businesses: Decodable {
    let businesses: [Business]
}

struct Business: Decodable {
    let id: String
    let name: String
    let imageUrl: URL
    let rating: Double // 1-5
    let price: String?
    let distance: Double // Meters
    let location: Location
    let phone: String
    let displayPhone: String
}

struct Location: Decodable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String?
    let zipCode: String?
    let country: String?
    let state: String?
    let displayAddress: [String]
}
