//
//  ImageCacheTests.swift
//  LocalBusinessTests
//
//  Created by iAskedYou2nd on 10/6/22.
//

import XCTest
@testable import LocalBusiness

class ImageCacheTests: XCTestCase {
    
    let imageKey = "ImageKey"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        ImageCache.shared.resetCache()
        try super.tearDownWithError()
    }

    func testImageCacheIsEmpty() {
        let imageData = ImageCache.shared[self.imageKey]
        
        XCTAssertNil(imageData)
    }
    
    func testImageCacheInsert() {
        let imageData = UIImage(named: "question-mark")?.jpegData(compressionQuality: 1.0)
        ImageCache.shared[self.imageKey] = imageData
        
        let imageDataPulled = ImageCache.shared[self.imageKey]
        
        XCTAssertEqual(imageData, imageDataPulled)
    }

    func testImageCacheRemoval() {
        let imageData = UIImage(named: "question-mark")?.jpegData(compressionQuality: 1.0)
        ImageCache.shared[self.imageKey] = imageData
        
        ImageCache.shared[self.imageKey] = nil
        let imageDataPulled = ImageCache.shared[self.imageKey]
        
        XCTAssertNil(imageDataPulled)
    }
    
}

extension ImageCache {
    
    func resetCache() {
        self.cache.removeAllObjects()
    }
    
}
