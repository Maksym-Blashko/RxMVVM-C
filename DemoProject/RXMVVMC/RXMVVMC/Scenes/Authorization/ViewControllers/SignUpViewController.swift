//
//  SignUpViewController.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD

protocol SignUpViewControllerDelegate: class {
    func didSignUp()
}

class SignUpViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userNameErrorLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var repeatPasswordErrorLabel: UILabel!
    
    @IBOutlet weak var signUp: UIButton!
    
    // MARK: - Properties
    weak var delegate: SignUpViewControllerDelegate?
    var viewModel: SignUpViewModeling!
    
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
    
    private var repeatPasswordErrorMessage: String? = nil {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.repeatPasswordErrorLabel.isHiddenInStackView = self.repeatPasswordErrorMessage == nil
                self.view.layoutIfNeeded()
            }
            repeatPasswordErrorLabel.text = repeatPasswordErrorMessage
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        bind(to: viewModel)
    }
    
    // MARK: - Methods
    func bind(to viewModel: SignUpViewModeling) {
        rx.disposeBag.insert(
            // MARK: VM Inputs
            userNameTextField.rx.text.orEmpty
                .do(onNext: {[weak self] _ in
                    self?.userNameTextField.backgroundColor = .white
                    self?.userNameErrorMessage = nil
                }).bind(to: viewModel.email),
            passwordTextField.rx.text.orEmpty
                .do(onNext: {[weak self] _ in
                    self?.passwordTextField.backgroundColor = .white
                    self?.passwordErrorMessage = nil
                }).bind(to: viewModel.password),
            repeatPasswordField.rx.text.orEmpty.do(onNext: {[weak self] _ in
                self?.repeatPasswordField.backgroundColor = .white
                self?.repeatPasswordErrorMessage = nil
            }).bind(to: viewModel.passwordRepeat),
            signUp.rx.tap.throttle(.milliseconds(20), scheduler: MainScheduler.instance).bind(to: viewModel.signUpTap),
            // MARK: VM Outputs
            viewModel.isLoading.drive(onNext: { isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            }),
            
            viewModel.error.drive(onNext: { error in
                SVProgressHUD.showError(withStatus: error)
            }),
            
            viewModel.validationOutput.drive(onNext: {[weak self] validation in
                print(validation)
                self?.apply(validation)
            }),
            
            viewModel.didSignUp.drive(onNext: {[weak self] didSucced in
                guard didSucced else { return }
                self?.delegate?.didSignUp()
            })
            
        )
    }
    
    private func apply(_ validationResult: SignUpModelValidationResult) {
        let errorBGColor = UIColor.red.withAlphaComponent(0.3)
        userNameTextField.backgroundColor = validationResult.isNameValid ? .white : errorBGColor
        passwordTextField.backgroundColor = (validationResult.isPasswordValid && validationResult.isPasswordHasValidLength) ? .white : errorBGColor
        if !validationResult.isNameValid {
            userNameErrorMessage = "Email is not valid"
        }
        if !validationResult.isPasswordValid {
            passwordErrorMessage = "Pasword is not valid"
        }
        if !validationResult.isPasswordHasValidLength {
            passwordErrorMessage = "Pasword is too short"
        }
        if !validationResult.doesPasswordsMatch {
            repeatPasswordErrorMessage = "Passwords does not match"
        }
    }
    deinit {
        print("Im dead \(self.description)")
    }
}
