//
//  ReviewViewModel.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 12/2/22.
//

import Foundation
import Combine

class ReviewViewModel {
    
    private let review: Review
    private let networkManager: NetworkManagerType
    private let dateFormatter: DateFormatter
    private var subs = Set<AnyCancellable>()
    @Published var imageData: Data = Data()
    
    init(review: Review, dateFormatter: DateFormatter, networkManager: NetworkManagerType) {
        self.review = review
        self.dateFormatter = dateFormatter
        self.networkManager = networkManager
    }
    
    var name: String {
        return self.review.user.name
    }
    
    var rating: String {
        return "\(self.review.rating)/5"
    }
    
    var date: String {
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = self.dateFormatter.date(from: self.review.timeCreated)
            else { return "N/A" }
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    var text: String {
        return self.review.text
    }
    
    func getImageData() {
        guard let urlStr = self.review.user.imageUrl, let url = URL(string: urlStr) else { return }
        
        if let imageData = ImageCache.shared[urlStr] {
            debugPrint("Image from Cache")
            self.imageData = imageData
            return
        }
        
        self.networkManager.getRawData(request: URLRequest(url: url))
            .sink { completion in
                if case .failure(let error) = completion {
                    // error handle
                    print(error)
                }
            } receiveValue: { [weak self] data in
                debugPrint("Image Received from network")
                guard let self = self else { return }
                ImageCache.shared[urlStr] = data
                self.imageData = data
            }.store(in: &self.subs)
    }
    
}
