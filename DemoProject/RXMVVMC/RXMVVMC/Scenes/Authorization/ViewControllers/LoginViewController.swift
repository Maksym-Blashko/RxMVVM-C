//
//  LoginViewController.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD

protocol LoginViewControllerDelegate: class {
    func didLogIn()
    func didTapSignUp()
}

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userNameErrorLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: Properties
    weak var delegate: LoginViewControllerDelegate?
    var viewModel: LoginViewModeling!
    
    private var userNameErrorMessage: String? = nil {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.userNameErrorLabel.isHiddenInStackView = self.userNameErrorMessage == nil
                self.view.layoutIfNeeded()
            }
            userNameErrorLabel.text = userNameErrorMessage
        }
    }
    
    private var passwordErrorMessage: String? = nil {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.passwordErrorLabel.isHiddenInStackView = self.passwordErrorMessage == nil
                self.view.layoutIfNeeded()
            }
            passwordErrorLabel.text = passwordErrorMessage
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        bind(to: viewModel)
    }
    
    // MARK: Methods
    func bind(to viewModel: LoginViewModeling) {
        rx.disposeBag.insert(
            // MARK: VM Inputs
            userNameTextField.rx.text.orEmpty
                .do(onNext: {[weak self] _ in
                    self?.userNameTextField.backgroundColor = .white
                    self?.userNameErrorMessage = nil
                }).bind(to: viewModel.name),
            
            passwordTextField.rx.text.orEmpty
                .do(onNext: {[weak self] _ in
                    self?.passwordTextField.backgroundColor = .white
                    self?.passwordErrorMessage = nil
                }).bind(to: viewModel.password),
            
            logInButton.rx.tap
                .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
                .bind(to: viewModel.logInTap),
            
            signUpButton.rx.tap
                .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
                .subscribe(onNext: {[weak self] _ in
                self?.delegate?.didTapSignUp()
            }),
            
            // MARK: VM Outputs
            viewModel.validationOutput.drive(onNext: {[weak self] validationResult in
                self?.apply(validationResult)
            }),
            
            viewModel.isLoading.drive(onNext: { isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            }),
            
            viewModel.didLogIn.drive(onNext: {[weak self] didLogIn in
                guard didLogIn else { return }
                self?.delegate?.didLogIn()
            }),
            
            viewModel.error.drive(onNext: { errorMessage in
                SVProgressHUD.showError(withStatus: errorMessage)
            }),
            
            viewModel.loginButtonEnabled.drive(onNext: {[weak self] isEnabled in
                self?.logInButton.isEnabled = isEnabled
                self?.logInButton.alpha = isEnabled ? 1 : 0.5
            })
        )
    }
    
    deinit {
        print("Im dead \(self.description)")
    }
    
    private func apply(_ validationResult: CredentialsValidationResult) {
        let errorBGColor = UIColor.red.withAlphaComponent(0.3)
        userNameTextField.backgroundColor = validationResult.isNameValid ? .white : errorBGColor
        passwordTextField.backgroundColor = (validationResult.isPasswordValid && validationResult.isPasswordHasValidLength) ? .white : errorBGColor
        if !validationResult.isNameValid {
            userNameErrorMessage = "User name is not valid"
        }
        if !validationResult.isPasswordValid {
            passwordErrorMessage = "Pasword is not valid"
        }
        if !validationResult.isPasswordHasValidLength {
            passwordErrorMessage = "Pasword is too short"
        }
    }
}
