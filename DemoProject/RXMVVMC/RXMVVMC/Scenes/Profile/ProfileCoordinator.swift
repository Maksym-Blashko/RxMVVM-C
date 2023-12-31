//
//  ProfileCoordinator.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

protocol ProfileCoordinatorDelegate: class {
    func userDidLogout()
}
/**
 Manages the Profile tab's navigation flow.
 */
class ProfileCoordinator: Coordinator<DeepLink> {
    private lazy var myProfileVC: MyProfileViewController = {
        let vc = self.myProfileVCFactory()
        vc.delegate = self
        return vc
    }()

    private let userSessionRepository: UserSessionRepository
    private let demoCoodrinatorFactory: (RouterType) -> DemoFlowCoordinator
    private let myProfileVCFactory: () -> MyProfileViewController
    weak var delegate: ProfileCoordinatorDelegate?

    init(router: RouterType,
         userSessionRepo: UserSessionRepository,
         myProfileVCFactory: @escaping () -> MyProfileViewController,
         demoFlowCoordinatorFactory: @escaping (RouterType) -> DemoFlowCoordinator) {
        self.myProfileVCFactory = myProfileVCFactory
        userSessionRepository = userSessionRepo
        demoCoodrinatorFactory = demoFlowCoordinatorFactory
        super.init(router: router)
    }
    
    override func start(with link: DeepLinkType?) {
        router.setRootModule(myProfileVC, hideBar: false, animated: false)
    }
}

// MARK: - Navigation
extension ProfileCoordinator {
    private func showHorizontalDemoFlow() {
        let coordinator = demoCoodrinatorFactory(router)
        coordinator.delegate = self
        addChild(coordinator)
        coordinator.start()
    }
}

extension ProfileCoordinator: MyProfileViewControllerDelegate {
    func didLogout() {
        delegate?.userDidLogout()
    }
    
    func didTapBarButton() {
        showHorizontalDemoFlow()
    }
}

extension ProfileCoordinator: DemoFlowCoordinatorDelegate {
    func didFinishFlow(for coordinator: Coordinator<DeepLink>) {
        removeChild(coordinator)
    }
}
