//
//  DebugSettings.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/11/22.
//

import Foundation

final class DebugSettings {
    
    static let shared = DebugSettings()

    var longitude: Double = -118.21241904417631
    var lattitude: Double = 33.83422265228964
    
    var throttleTime: Int = 0
    var intervalThrottleTime: DispatchTimeInterval {
        return .seconds(throttleTime)
    }
    
    private init() { }

}
