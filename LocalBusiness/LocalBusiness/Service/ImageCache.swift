//
//  ImageCache.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/5/22.
//

import Foundation

final class ImageCache {
    
    static let shared = ImageCache()
    
    let cache = NSCache<NSString, NSData>()
    
    private init() { }
    
    subscript(key: String) -> Data? {
        get {
            let nsKey = NSString(string: key)
            guard let nsData = self.cache.object(forKey: nsKey) else { return nil }
            return Data(referencing: nsData)
        }
        set {
            let nsKey = NSString(string: key)
            if let data = newValue {
                let nsDataObject = NSData(data: data)
                self.cache.setObject(nsDataObject, forKey: nsKey)
            } else {
                self.cache.removeObject(forKey: nsKey)
            }
        }
    }
    
}

