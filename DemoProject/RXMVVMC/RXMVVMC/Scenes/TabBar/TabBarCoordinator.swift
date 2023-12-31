//
//  TabBarControllerCoordinator.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import RxSwift

protocol TabBarCoordinatorDelegate: class {
    func didLogout()
}

/**
 Sets the tabBarController as the root VC in the navigationStack.
 Instantiates, stores and starts coordinators for each tab.
 Notify the AppCoordinator if the user has logged out via delegation
 */

class TabBarCoordinator: Coordinator<DeepLink> {
    private let tabController: UITabBarController = {
        let vc = UITabBarController()
        vc.tabBar.isTranslucent = true
        vc.view.tintColor = .orange
        return vc
    }()
    
    private let moviesCoordinatorFacrory: () -> MoviesCoordinator
    private let profileCoordinatorFactory: () -> ProfileCoordinator
    
    var tabs: [UIViewController: Coordinator<DeepLink>] = [:]
    weak var delegate: TabBarCoordinatorDelegate?
    
    init(router: RouterType,
         moviesCoordinatorFactory: @escaping () -> MoviesCoordinator,
         profileCoordinatorFactory: @escaping () -> ProfileCoordinator) {
        self.moviesCoordinatorFacrory = moviesCoordinatorFactory
        self.profileCoordinatorFactory = profileCoordinatorFactory
        super.init(router: router)
    }
    
    override func start(with link: DeepLink?) {
        let profileCoordinator = profileCoordinatorFactory()
        profileCoordinator.delegate = self
        profileCoordinator.start()
        let moviesCoordinator = moviesCoordinatorFacrory()
        moviesCoordinator.start()
        setTabs([moviesCoordinator,
                 profileCoordinator], animated: false)
        router.setRootModule(self, hideBar: true, animated: true)
    }
    
    private func setTabs(_ coordinators: [Coordinator<DeepLink>], animated: Bool = false) {
        tabs = [:]
        // Store view controller to coordinator mapping
        let vcs = coordinators.map { coordinator -> UIViewController in
            let viewController = coordinator.toPresentable()
            tabs[viewController] = coordinator
            return viewController
        }
        tabController.setViewControllers(vcs, animated: animated)
    }
    override func toPresentable() -> UIViewController { tabController }
}

extension TabBarCoordinator: ProfileCoordinatorDelegate {
    func userDidLogout() {
        delegate?.didLogout()
    }
}
