//
//  ProfileDIContainer.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import Swinject
import RxSwift
//swiftlint:disable force_unwrapping
class ProfileDIContainer {
    private let container: Container
    init(parentContainer: Container) {
        container = Container(parent: parentContainer) { container in
            // MARK: My profile
            container.register(MyProfileViewModeling.self) { resolver -> MyProfileViewModeling in
                MyProfileControllerViewModel(userSessionRepository: resolver.resolve(UserSessionRepository.self)!)
            }
            container.register(MyProfileViewController.self) { resolver -> MyProfileViewController in
                let sb = UIStoryboard(.profile)
                let vc: MyProfileViewController = sb.instantiateViewController()
                vc.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
                vc.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
                vc.tabBarItem.title = "Profile"
                vc.navigationItem.title = "Profile"
                vc.viewModel = resolver.resolve(MyProfileViewModeling.self)!
                return vc
            }
            // MARK: Coordinator
            container.register(ProfileCoordinator.self) { resolver -> ProfileCoordinator in
                let demoDI = DemoDIContainer(parentContainer: container)
                
                let navVC = UINavigationController()
                navVC.navigationBar.isTranslucent = true
                let router = Router(navigationController: navVC)
                let myProfileFactory: () -> MyProfileViewController = {
                    resolver.resolve(MyProfileViewController.self)!
                }
                let demoCoordinatorFactory: (RouterType) -> DemoFlowCoordinator = { router in
                    demoDI.makeDemoFlowCoordinator(router)
                }
                return ProfileCoordinator(router: router,
                                          userSessionRepo: container.resolve(UserSessionRepository.self)!,
                                          myProfileVCFactory: myProfileFactory,
                                          demoFlowCoordinatorFactory: demoCoordinatorFactory)
            }
        }
    }
    
    func makeProfileCoordinator() -> ProfileCoordinator { container.resolve(ProfileCoordinator.self)! }
}
