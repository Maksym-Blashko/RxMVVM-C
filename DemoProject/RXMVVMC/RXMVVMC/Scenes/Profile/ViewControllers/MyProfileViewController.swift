//
//  MyProfileViewController.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

protocol MyProfileViewControllerDelegate: class {
    func didLogout()
    func didTapBarButton()
}

class MyProfileViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var barButton: UIBarButtonItem!
    @IBOutlet private weak var userIDLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var sessionIDLabel: UILabel!
    
    // MARK: Properties
    weak var delegate: MyProfileViewControllerDelegate?
    var viewModel: MyProfileViewModeling!
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
    }

    // MARK: Methods
    func bind(to viewModel: MyProfileViewModeling) {
        rx.disposeBag.insert(
            barButton.rx.tap.subscribe(onNext: { [weak self] _ in
                self?.delegate?.didTapBarButton()
            }),
            // MARK: VM Inputs
            logoutButton.rx.tap.bind(to: viewModel.logoutTap),
            // MARK: VM Outputs
            viewModel.userSession.subscribe(onNext: { [weak self] session in
                self?.userIDLabel.text = session.userID
                self?.userNameLabel.text = session.userName
                self?.sessionIDLabel.text = session.sessionID
            }),
            viewModel.didLogout.drive(onNext: { [weak self] didLogout in
                guard didLogout else { return }
                self?.delegate?.didLogout()
            }),
            viewModel.isLoading.drive(onNext: { isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            }),
            viewModel.errors.drive(onNext: { error in
                SVProgressHUD.showError(withStatus: error)
            })
        )
    }
}
