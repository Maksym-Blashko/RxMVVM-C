//
//  Encodable + Dictionary.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 06.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

extension Encodable {
    func toDictionary(encodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = encodingStrategy
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
