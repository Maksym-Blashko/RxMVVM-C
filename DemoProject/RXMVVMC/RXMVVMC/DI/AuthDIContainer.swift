//
//  AuthDIContainer.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import Swinject
import RxSwift

//It's ok to supress linter here.
//swiftlint:disable force_unwrapping
class AuthDIContainer {
    private let container: Container
    
    init(parentContainer: Container) {
        container = Container(parent: parentContainer) { container in
            // MARK: - Authorization
            // MARK: Login
            container.register(LoginViewModeling.self) { resolver in
                let factory: (Observable<LoginModel>) -> CredentialsValidator = { loginModel in
                    CredentialsValidator(input: loginModel)
                }
                return LoginControllerViewModel(userSessionRepository: resolver.resolve(UserSessionRepository.self)!,
                                                validatorFactory: factory)
            }
            container.register(LoginViewController.self) { resolver in
                let sb = UIStoryboard(.authorization)
                let vc: LoginViewController = sb.instantiateViewController()
                vc.navigationItem.title = "Sign in"
                vc.viewModel = resolver.resolve(LoginViewModeling.self)!
                return vc
            }
            
            // MARK: SignUP
            container.register(SignUpViewModeling.self) { resolver in
                let factory: (Observable<NewAccount>) -> SignUpModelValidator = { model in
                    SignUpModelValidator(input: model)
                }
                return SignUpControllerViewModel(userSessionRepo: resolver.resolve(UserSessionRepository.self)!,
                                                 validatorFactory: factory)
            }
            
            container.register(SignUpViewController.self) { resolver in
                let sb = UIStoryboard(.authorization)
                let vc: SignUpViewController = sb.instantiateViewController()
                vc.viewModel = resolver.resolve(SignUpViewModeling.self)!
                return vc
            }
        }
    }
    
    func makeLoginVC() -> LoginViewController { container.resolve(LoginViewController.self)! }
    func makeSignUpVC() -> SignUpViewController { container.resolve(SignUpViewController.self)! }
}
