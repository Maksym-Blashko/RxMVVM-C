//
//  Data + DecodeTo.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 06.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

extension Data {
    func decodeTo<T: Decodable>(type: T.Type,
                                strategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = strategy
        return try decoder.decode(type, from: self)
    }
}
