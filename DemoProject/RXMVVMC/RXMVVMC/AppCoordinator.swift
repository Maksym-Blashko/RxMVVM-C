//
//  AppCoordinator.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 04.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

enum DeepLink {
    case auth
}

import UIKit
import RxSwift
/**
 The main coordinator of the app.
 Here we decide which flow to start first.
 If the user was already logged in ->  It starts the tabBar coordinator.
 If not -> AuthorizationCoordinator.
 */
class AppCoordinator: Coordinator<DeepLink> {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let authCoordinatorFactory: (RouterType) -> AuthorizationCoordinator
    private let tabBarCoordinatorFactory: (RouterType) -> TabBarCoordinator
    private let userSessionRepository: UserSessionRepository
    // MARK: - Methods
    init(router: RouterType,
         userRepo: UserSessionRepository,
         authCoordinatorFactory: @escaping (RouterType) -> AuthorizationCoordinator,
         tabBarCoordinatorFactory: @escaping (RouterType) -> TabBarCoordinator) {
        self.tabBarCoordinatorFactory = tabBarCoordinatorFactory
        self.authCoordinatorFactory = authCoordinatorFactory
        userSessionRepository = userRepo
        super.init(router: router)
    }
    
    override func start(with link: DeepLink?) {
        guard let link = link else {
            selectRigthFlow()
            return
        }
        switch link {
        case .auth:
            goToLoginFlow()
        }
    }
    
    private func selectRigthFlow() {
        userSessionRepository.readUserSession()
            .subscribe(onSuccess: {[weak self] session in
                guard session == nil  else {
                    self?.presentTabBarCoordinator()
                    return
                }
                self?.goToLoginFlow()
            }).disposed(by: disposeBag)
    }
    
}

// MARK: - Navigation
extension AppCoordinator {
    func goToLoginFlow() {
        childCoordinators.removeAll()
        let coordinator = authCoordinatorFactory(router)
        addChild(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
    
    func presentTabBarCoordinator() {
        childCoordinators.removeAll()
        let coordinator = tabBarCoordinatorFactory(router)
        addChild(coordinator)
        coordinator.delegate = self
        coordinator.start()
    }
}

extension AppCoordinator: TabBarCoordinatorDelegate {
    func didLogout() {
        goToLoginFlow()
    }
}

extension AppCoordinator: AuthorizationCoordinatorDelegate {
    func didAuthorize() {
        presentTabBarCoordinator()
    }
}
