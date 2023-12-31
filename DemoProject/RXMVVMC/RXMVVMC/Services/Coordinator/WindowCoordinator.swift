//
//  WindowCoordinator.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

protocol WindowCoordinatorType: BaseCoordinatorType {
    var router: WindowRouterType { get }
}

class WindowCoordinator<DeepLinkType>: NSObject, WindowCoordinatorType {
    
    var childCoordinators: [PresentableCoordinator<DeepLinkType>] = []
    var router: WindowRouterType
    
    init(router: WindowRouterType) {
        self.router = router
        super.init()
    }
    
    func start() { start(with: nil) }
    func start(with link: DeepLinkType?) {}
    
    func addChild(_ coordinator: Coordinator<DeepLinkType>) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator<DeepLinkType>?) {
        guard let coordinator = coordinator, let index = childCoordinators.firstIndex(of: coordinator) else { return }
        childCoordinators.remove(at: index)
    }
}
