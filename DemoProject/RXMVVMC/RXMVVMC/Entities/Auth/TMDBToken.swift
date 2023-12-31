//
//  TMDBToken.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 06.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

struct TMDBToken: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: RequestToken
}
