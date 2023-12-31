//
//  EmailValidator.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

protocol EmailValidator {
    func isEmailValid(_ email: String) -> Bool
}

extension EmailValidator {
    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

protocol NameValidator {
    func isNameValid( _ name: String) -> Bool
}

extension NameValidator {
    func isNameValid(_ name: String) -> Bool {
        name.count > 3
    }
}
