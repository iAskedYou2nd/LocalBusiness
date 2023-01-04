//
//  ReviewListViewModel.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 12/2/22.
//

import Foundation
import Combine

class ReviewListViewModel {
    
    @Published var reviews: [Review] = []
    let id: String
    private let networkManager: NetworkManagerType
    private var subs = Set<AnyCancellable>()
    private var reviewViewModels: [IndexPath: ReviewViewModel] = [:]
    private let dateFormatter = DateFormatter()
 
    init(id: String, networkManager: NetworkManagerType = NetworkManager()) {
        self.networkManager = networkManager
        self.id = id
    }
    
    var count: Int {
        return (self.reviews.count > 3) ? 3 : self.reviews.count
    }
    
    func fetchReviews() {
        let request = NetworkParams.businessReviews(id: self.id).urlRequest
        
        self.networkManager.getModel(request: request)
            .sink { completion in
                if case .failure(let error) = completion {
                    // error handle
                    print(error)
                }
            } receiveValue: { [weak self] (model: ReviewList) in
                debugPrint("Reviews Aquired")
                self?.reviews = model.reviews
            }.store(in: &self.subs)
        
    }
    
    func reviewViewModel(for index: IndexPath) -> ReviewViewModel? {
        guard index.row < self.reviews.count else { return nil }
        if let reviewViewModel = self.reviewViewModels[index] {
            return reviewViewModel
        } else {
            let reviewViewModel = ReviewViewModel(review: self.reviews[index.row], dateFormatter: self.dateFormatter, networkManager: self.networkManager)
            self.reviewViewModels[index] = reviewViewModel
            return reviewViewModel
        }
    }
    
}
