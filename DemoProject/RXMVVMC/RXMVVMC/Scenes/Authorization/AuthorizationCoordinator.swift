//
//  AuthorizationCoordinator.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import RxSwift

protocol AuthorizationCoordinatorDelegate: class {
    func didAuthorize()
}
/**
Manages the authorization flow.
Sets  the LoginViewController as rootVC in the navigationStack.
Notify the AppCoordinator if the user has signed in via delegation.
*/

class AuthorizationCoordinator: Coordinator<DeepLink> {
    private let userSessionRepository: UserSessionRepository
    
    lazy var loginVC: LoginViewController = {
        let vc = self.loginVCFactory()
        vc.navigationItem.hidesBackButton = true
        vc.delegate = self
        return vc
    }()

    private let loginVCFactory: () -> LoginViewController
    private let signUpVCFactory: () -> SignUpViewController
    weak var delegate: AuthorizationCoordinatorDelegate?
    
    init(router: RouterType,
         userRepo: UserSessionRepository,
         loginVCFactory: @escaping () -> LoginViewController,
         signUpVCFactory: @escaping () -> SignUpViewController) {
        userSessionRepository = userRepo
        self.loginVCFactory = loginVCFactory
        self.signUpVCFactory = signUpVCFactory
        super.init(router: router)
    }
    
    override func start(with link: DeepLink?) {
        guard link != nil else {
            router.setRootModule(self, hideBar: false, animated: true)
            return
        }
    }
    
    deinit {
        print("\(self) is dead")
    }
    // We must override toPresentable() so it doesn't
    // default to the router's navigationController
    override func toPresentable() -> UIViewController { loginVC }
}

extension AuthorizationCoordinator {
    func goToSignUp() {
        let signUpVC = signUpVCFactory()
        signUpVC.delegate = self
        router.push(signUpVC, animated: true, completion: nil)
    }
}

extension AuthorizationCoordinator: LoginViewControllerDelegate {
    func didLogIn() {
       delegate?.didAuthorize()
    }
    
    func didTapSignUp() {
        goToSignUp()
    }
}

extension AuthorizationCoordinator: SignUpViewControllerDelegate {
    func didSignUp() {
        delegate?.didAuthorize()
    }
}
