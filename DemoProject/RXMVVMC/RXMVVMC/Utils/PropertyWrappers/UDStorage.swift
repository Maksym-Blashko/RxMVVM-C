//
//  UDStorage.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 06.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

///Property wrapper for working with the UserDefaults storage
@propertyWrapper
struct UDStorage<T: Codable> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }
            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)
            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
