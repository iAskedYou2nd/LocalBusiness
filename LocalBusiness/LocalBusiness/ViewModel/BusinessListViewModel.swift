//
//  BusinessListViewModel.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/5/22.
//

import Foundation
import Combine

protocol BusinessListViewModelType {
    var businesses: [Business] { get }
    func fetchBusinesses()
}

class BusinessListViewModel: BusinessListViewModelType {
    
    @Published var businesses: [Business] = []
    private let networkManager: NetworkManagerType
    private var subs = Set<AnyCancellable>()
    private var businessViewModels: [IndexPath: BusinessViewModel] = [:]
    
    init(networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchBusinesses() {
        
        let request = NetworkParams.nearbyBusinessSearch(lat: DebugSettings.shared.lattitude, long: DebugSettings.shared.longitude).urlRequest
        self.networkManager.getModel(request: request)
            .sink { completion in
                if case .failure(let error) = completion {
                    // error handle
                    print(error)
                }
            } receiveValue: { [weak self] (model: Businesses) in
                debugPrint("Models Aquired")
                self?.businesses = model.businesses
            }.store(in: &self.subs)
    }
    
    func businessViewModel(for index: IndexPath) -> BusinessViewModel? {
        guard index.row < self.businesses.count else { return nil }
        if let businessViewModel = self.businessViewModels[index] {
            return businessViewModel
        } else {
            let businessViewModel = BusinessViewModel(business: self.businesses[index.row], networkManager: self.networkManager)
            self.businessViewModels[index] = businessViewModel
            return businessViewModel
        }
    }
    
}

