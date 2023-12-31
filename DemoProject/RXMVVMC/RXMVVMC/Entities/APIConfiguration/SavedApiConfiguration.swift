//
//  SavedApiConfiguration.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 17.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

///Container for APIConfiguration which also stores the last saved date info
struct SavedApiConfiguration: Codable {
    let config: APIConfiguration
    let dateSaved: Date
    
    static var defaultConfig: SavedApiConfiguration {
        SavedApiConfiguration(config: APIConfiguration.defaultConfig, dateSaved: Date().adjust(.day, offset: -2))
    }
}
