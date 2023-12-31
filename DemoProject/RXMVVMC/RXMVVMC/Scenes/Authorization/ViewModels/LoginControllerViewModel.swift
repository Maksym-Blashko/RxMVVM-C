//
//  LoginControllerViewModel.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModeling {
    // MARK: - Input
    var name: AnyObserver<String> { get }
    var password: AnyObserver<String> { get }
    var logInTap: AnyObserver<Void> { get }
    // MARK: - Output
    var isLoading: Driver<Bool>! { get }
    var didLogIn: Driver<Bool>! { get }
    var loginButtonEnabled: Driver<Bool>! { get }
    var validationOutput: Driver<CredentialsValidationResult>! { get }
    var error: Driver<String>! { get }
}

class LoginControllerViewModel: LoginViewModeling {

    // MARK: - Properties
    private let sessionRepository: UserSessionRepository
    private var validator: CredentialsValidator!
    // MARK: - Factories
    private let makeCredValidator: (Observable<LoginModel>) -> CredentialsValidator

    // MARK: - Subjects
    private let _name = PublishSubject<String>()
    private let _logInTap = PublishSubject<Void>()
    private let _password = PublishSubject<String>()

    // MARK: - Input
    var name: AnyObserver<String> {  _name.asObserver() }
    var password: AnyObserver<String> { _password.asObserver() }
    var logInTap: AnyObserver<Void> { _logInTap.asObserver() }

    // MARK: - Output
    var isLoading: Driver<Bool>!
    var didLogIn: Driver<Bool>!
    var loginButtonEnabled: Driver<Bool>!
    var validationOutput: Driver<CredentialsValidationResult>!
    var error: Driver<String>!

    // MARK: - Methods
    init(userSessionRepository: UserSessionRepository,
         validatorFactory: @escaping (Observable<LoginModel>) -> CredentialsValidator) {
        sessionRepository = userSessionRepository
        makeCredValidator = validatorFactory
        bindOutput()
    }

    private func bindOutput() {
        let modelToValidate = loginModel()
        self.validator = makeCredValidator(modelToValidate)
        let validationResult = validator.validate().share()
        let validModel = validationResult.filter { $0.validationResult.isAllValid }.map { $0.model }
 
        validationOutput = validationResult.map { $0.validationResult }
            .asDriver(onErrorJustReturn: CredentialsValidationResult(isNameValid: false,
                                                                     isPasswordHasValidLength: false,
                                                                     isPasswordValid: false))
        loginButtonEnabled = isLoginButtonEnabled()

        let loginRequest = login(validModelObs: validModel).share()

        didLogIn = loginRequest.compactMap { $0.element }
            .map { _ in true }.asDriver(onErrorJustReturn: false)

        error = loginRequest.compactMap { $0.error}.map { $0.localizedDescription }.asDriver(onErrorJustReturn: "")

        isLoading = Observable<Bool>.merge(validModel.map { _ in true },
                                           loginRequest.map { _ in false })
            .asDriver(onErrorJustReturn: false)
    }
    
    private func login(validModelObs: Observable<LoginModel>) -> Observable<Event<UserSession>> {
        let userRepo = sessionRepository
        return validModelObs.flatMapLatest { model -> Observable<Event<UserSession>> in
            userRepo.signIn(userName: model.userName, password: model.password).asObservable().materialize()
        }
    }

    private func loginModel() -> Observable<LoginModel> {
        let model = Observable.combineLatest(_name, _password) { mail, password -> LoginModel in
            return LoginModel(userName: mail, password: password)
        }
        return _logInTap.withLatestFrom(model)
    }

    private func isLoginButtonEnabled() -> Driver<Bool> {
        Observable.combineLatest(_name.startWith(""), _password.startWith("")) { mail, pass -> Bool in
            return mail.count > 3 && pass.count > 3
        }.asDriver(onErrorJustReturn: false)
    }
}
