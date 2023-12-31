//
//  CredentialsValidationResult.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 04.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

class CredentialsValidator: PasswordValidator & NameValidator {
    var input: Observable<LoginModel>
    
    init(input: Observable<LoginModel>) {
        self.input = input
    }
    
    func validate() -> Observable<(validationResult: CredentialsValidationResult, model: LoginModel)> {
        return input.map {[weak self] model in
            guard let self = self else { fatalError("Should be retained") }
            let isNameValid = self.isNameValid(model.userName)
            let passwordValidationRes = self.isPasswordValid(model.password)
            return (validationResult: CredentialsValidationResult(isNameValid: isNameValid,
                                                                  isPasswordHasValidLength: passwordValidationRes.isNormalLength,
                                                                  isPasswordValid: passwordValidationRes.isValid), model: model)
        }
    }
}

struct CredentialsValidationResult {
    let isNameValid: Bool
    let isPasswordHasValidLength: Bool
    let isPasswordValid: Bool
    
    var isAllValid: Bool {
        return isNameValid && isPasswordValid && isPasswordHasValidLength
    }
}

class SignUpModelValidator: PasswordValidator & NameValidator {
    var input: Observable<NewAccount>
    
    init(input: Observable<NewAccount>) {
        self.input = input
    }
    
    func validate() -> Observable<(validationResult: SignUpModelValidationResult, model: NewAccount)> {
        return input.map {[weak self] model in
            guard let self = self else { fatalError("Should be retained") }
            let isEmailValid = self.isNameValid(model.name)
            let passValidationRes = self.isPasswordValid(model.password)
            let doesPasswordsMatch = model.password == model.repeatPassword
            return (validationResult: SignUpModelValidationResult(isNameValid: isEmailValid,
                                                                  isPasswordValid: passValidationRes.isValid,
                                                                  isPasswordHasValidLength: passValidationRes.isNormalLength,
                                                                  doesPasswordsMatch: doesPasswordsMatch), model: model)
        }
    }
}

struct SignUpModelValidationResult {
    let isNameValid: Bool
    let isPasswordValid: Bool
    let isPasswordHasValidLength: Bool
    let doesPasswordsMatch: Bool
    
    var isAllValid: Bool { isNameValid && isPasswordValid && isPasswordHasValidLength && doesPasswordsMatch }
}
