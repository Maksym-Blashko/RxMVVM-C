//
//  Coordinator.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//
import UIKit

protocol BaseCoordinatorType: class {
    associatedtype DeepLinkType
    func start()
    func start(with link: DeepLinkType?)
}

protocol PresentableCoordinatorType: BaseCoordinatorType, Presentable {}

class PresentableCoordinator<DeepLinkType>: NSObject, PresentableCoordinatorType {
    
    public override init() {
        super.init()
    }
    
    func start() { start(with: nil) }
    func start(with link: DeepLinkType?) {}
    
    func toPresentable() -> UIViewController {
        fatalError("Must override toPresentable()")
    }
}

protocol CoordinatorType: PresentableCoordinatorType {
    var router: RouterType { get }
}

class Coordinator<DeepLinkType>: PresentableCoordinator<DeepLinkType>, CoordinatorType {
    
    var childCoordinators: [Coordinator<DeepLinkType>] = []
    var router: RouterType
    
    init(router: RouterType) {
        self.router = router
        super.init()
    }
    
    func addChild(_ coordinator: Coordinator<DeepLinkType>) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator<DeepLinkType>?) {
        guard let coordinator = coordinator, let index = childCoordinators.firstIndex(of: coordinator)  else { return }
        childCoordinators.remove(at: index)
    }
    
    override func toPresentable() -> UIViewController { router.toPresentable() }
}
