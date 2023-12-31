//
//  SignUpControllerViewModel.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignUpViewModeling {
    // MARK: - Input
    var email: AnyObserver<String> { get }
    var password: AnyObserver<String> { get }
    var passwordRepeat: AnyObserver<String> { get }
    var signUpTap: AnyObserver<Void> { get }
    // MARK: - Output
    var isLoading: Driver<Bool>! { get }
    var didSignUp: Driver<Bool>! { get }
    var validationOutput: Driver<SignUpModelValidationResult>! { get }
    var error: Driver<String>! { get }
}

class SignUpControllerViewModel: SignUpViewModeling {
    // MARK: - Properties
    private let userSessionRepository: UserSessionRepository
    private var validator: SignUpModelValidator!
    // MARK: - Factories
    private let makeFieldsValidator: (Observable<NewAccount>) -> SignUpModelValidator

    // MARK: - Subjects
    private let _email = PublishSubject<String>()
    private let _password = PublishSubject<String>()
    private let _passwordRepeat = PublishSubject<String>()
    private let _signUpTap = PublishSubject<Void>()

    // MARK: - Input
    var email: AnyObserver<String> { _email.asObserver() }
    var password: AnyObserver<String> { _password.asObserver() }
    var passwordRepeat: AnyObserver<String> { _passwordRepeat.asObserver() }
    var signUpTap: AnyObserver<Void> { _signUpTap.asObserver() }
    
    // MARK: - Output
    var isLoading: Driver<Bool>!
    var didSignUp: Driver<Bool>!
    var validationOutput: Driver<SignUpModelValidationResult>!
    var error: Driver<String>!

    // MARK: - Methods
    init(userSessionRepo: UserSessionRepository,
         validatorFactory: @escaping (Observable<NewAccount>) -> SignUpModelValidator) {
        makeFieldsValidator = validatorFactory
        userSessionRepository = userSessionRepo
        bindOutput()
    }

    private func bindOutput() {
        let modelToValidate = model()
        validator = makeFieldsValidator(modelToValidate)
        let validationResult = validator.validate().share()
        let validModel = validationResult.filter { $0.validationResult.isAllValid }.map { $0.model }
        validationOutput = validationResult.map { $0.validationResult }.asDriver(onErrorJustReturn: SignUpModelValidationResult(isNameValid: false,
                                                                                                                                isPasswordValid: false,
                                                                                                                                isPasswordHasValidLength: false,
                                                                                                                                doesPasswordsMatch: false))
        let request = signUpRequest(validModelObs: validModel).share()
        didSignUp = request.compactMap { $0.element }.map { _ in true }.asDriver(onErrorJustReturn: false)
        error = request.compactMap { $0.error }.map { $0.localizedDescription }.asDriver(onErrorJustReturn: "")

        isLoading = Observable<Bool>.merge(validModel.map { _ in true },
                                           request.map { _ in false }).asDriver(onErrorJustReturn: false)

    }
    private func signUpRequest(validModelObs: Observable<NewAccount>) -> Observable<Event<UserSession>> {
        let userRepo = userSessionRepository
        return validModelObs.flatMapLatest { model -> Observable<Event<UserSession>> in
            userRepo.signUp(newAccount: model).asObservable().materialize()
        }
    }

    private func model() -> Observable<NewAccount> {
        let model = Observable.combineLatest(_email.startWith(""), _password.startWith(""), _passwordRepeat.startWith("")) { mail, password, passwordRepeat in
            NewAccount(name: mail, password: password, repeatPassword: passwordRepeat)
        }
        return _signUpTap.withLatestFrom(model)
    }
}
