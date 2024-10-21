//
//  UserDefaultsStorage.swift
//  VideoTrackView
//
//  Created by Jinyoung Yoo on 10/21/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

enum UserDefaultsStorage {
    
    enum Keys: String, CaseIterable {
        case videoTrackOrder
    }

    @UserDefault(key: Keys.videoTrackOrder.rawValue, defaultValue: nil)
    static var videoTrackOrder: [String]?
}
