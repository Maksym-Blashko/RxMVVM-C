//
//  TMDBError.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 06.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

struct TMDBError: Codable {
    let statusMessage: String?
    let statusCode: String?
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}
