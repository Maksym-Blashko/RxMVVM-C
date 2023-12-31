//
//  Optional+Required.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 13.12.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

// An extension that allows to get rid of annoying "forced unwrapping" warning.
extension Optional {
    // Require an optional to be non-nil.
    // Returns the value the optional contains or crashes with fatalError.
    func required(error: @autoclosure () -> String? = nil,
                 file: StaticString = #file,
                 line: Int = #line) -> Wrapped {
        guard let unwrapped = self else {
            let msg: String = {
                if let msg = error() { return ": \(msg)" }
                return ""
            }()
            fatalError("Required reference is nil in file \(file) at line: \(line)\(msg)")
        }
        return unwrapped
    }
}
