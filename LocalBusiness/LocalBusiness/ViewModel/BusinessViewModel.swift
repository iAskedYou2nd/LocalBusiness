//
//  BusinessViewModel.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/6/22.
//

import Foundation
import Combine

protocol BusinessViewModelType {
    var id: String { get }
    var name: String { get }
    var price: String { get }
    var rating: String { get }
    var distance: String { get }
}

class BusinessViewModel: BusinessViewModelType {
    
    private let business: Business
    private let networkManager: NetworkManagerType
    private var subs = Set<AnyCancellable>()
    @Published var imageData: Data = Data()
    
    init(business: Business, networkManager: NetworkManagerType) {
        self.business = business
        self.networkManager = networkManager
    }
    
    var id: String {
        return self.business.id
    }
    
    var name: String {
        return self.business.name
    }
    
    var price: String {
        return self.business.price ?? "N/A"
    }
    
    var rating: String {
        return "\(self.business.rating)/5"
    }
    
    var distance: String {
        let miles = self.business.distance / 1609.34
        return String(format: "%.1f mi", miles)
    }
    
    var address: String {
        return self.business.location.displayAddress.joined(separator: "\n")
    }
    
    var phoneNumber: String {
        return self.business.displayPhone
    }
    
    func getImageData() {
        if let imageData = ImageCache.shared[self.business.imageUrl.absoluteString] {
            debugPrint("Image from Cache")
            self.imageData = imageData
            return
        }
        
        self.networkManager.getRawData(request: URLRequest(url: self.business.imageUrl))
            .sink { completion in
                if case .failure(let error) = completion {
                    // error handle
                    print(error)
                }
            } receiveValue: { [weak self] data in
                debugPrint("Image Received from network")
                guard let self = self else { return }
                ImageCache.shared[self.business.imageUrl.absoluteString] = data
                self.imageData = data
            }.store(in: &self.subs)
    }
    
}

