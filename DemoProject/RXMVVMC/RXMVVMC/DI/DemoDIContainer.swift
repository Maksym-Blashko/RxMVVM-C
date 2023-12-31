//
//  DemoDIcontainer.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 10.12.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import Swinject
//swiftlint:disable force_unwrapping
class DemoDIContainer {
    private let container: Container
    
    init(parentContainer: Container) {
        self.container = Container(parent: parentContainer) { container in
            let sb = UIStoryboard(.demoflow)
            //First VC
            container.register(FirstViewController.self) { _ -> FirstViewController in
                return sb.instantiateViewController()
            }
            //Second VC
            container.register(SecondViewController.self) { _ -> SecondViewController in
                return sb.instantiateViewController()
            }
            
            //ThirdVC
            container.register(ThirdControllerViewModeling.self) { _ -> ThirdControllerViewModeling in
                ThirdControllerViewModel()
            }
            
            container.register(ThirdViewController.self) { resolver -> ThirdViewController in
                let vc: ThirdViewController = sb.instantiateViewController()
                vc.viewModel = resolver.resolve(ThirdControllerViewModeling.self)!
                return vc
            }
            
            container.register(DemoFlowCoordinator.self) { (resolver, router: RouterType) -> DemoFlowCoordinator in
                let factories = DemoCoordinatorFactories(firstVCFactory: { resolver.resolve(FirstViewController.self)!},
                                                              secondVCFactory: { resolver.resolve(SecondViewController.self)!},
                                                              thirdVCFactory: { resolver.resolve(ThirdViewController.self)!})
                
                return DemoFlowCoordinator(router: router, factories: factories)
            }
        }
    }
    
    func makeDemoFlowCoordinator(_ router: RouterType) -> DemoFlowCoordinator { container.resolve(DemoFlowCoordinator.self, argument: router)! }
}

