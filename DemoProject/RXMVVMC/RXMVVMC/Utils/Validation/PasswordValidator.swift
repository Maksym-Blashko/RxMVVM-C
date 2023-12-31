//
//  PasswordValidator.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

protocol PasswordValidator {
    func isPasswordValid(_ password: String) -> (isValid: Bool, isNormalLength: Bool)
}

extension PasswordValidator {
    func isPasswordValid(_ password: String) -> (isValid: Bool, isNormalLength: Bool) {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[A-Z])[A-Za-z\\d !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let isPasswortValid = passwordTest.evaluate(with: password)
        let isPasswordHasValidLength = (8...30).contains(password.count)
        return (isValid: isPasswortValid, isNormalLength: isPasswordHasValidLength)
    }
}
