//
//  DemoflowCoordinator.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 10.12.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

struct DemoCoordinatorFactories {
    let firstVCFactory: () -> FirstViewController
    let secondVCFactory: () -> SecondViewController
    let thirdVCFactory: () -> ThirdViewController
}

protocol DemoFlowCoordinatorDelegate: class {
    func didFinishFlow(for coordinator: Coordinator<DeepLink>)
}

/**
Coordinator for  "Horizontal Flow" routing handling demonstration.
"Horizontal flow" means that the parent and child coordinators share the same  router ( and accordingly the navigation controller )
In order to child controller to be deallocated we must to notify the parent cordinator that the user leaves the flow coordinated by child controller.
Then it is the parent coordinator's responsibility to call removeChlid(_ :Coordinator<DeepLink>)
*/
class DemoFlowCoordinator: Coordinator<DeepLink> {
    private lazy var firstVC: FirstViewController = {
        let vc = self.factories.firstVCFactory()
        vc.delegate = self
        return vc
    }()
    weak var delegate: DemoFlowCoordinatorDelegate?
    private let factories: DemoCoordinatorFactories
    
    init(router: RouterType, factories: DemoCoordinatorFactories) {
        self.factories = factories
        super.init(router: router)
    }
    
    override func start(with link: DeepLink?) {
        router.push(self, animated: true, completion: { [weak self] in
            guard let self = self else { return }
            //Here we notify the parent coordinator that the user leaves the flow and coordinator can be removed from the parent's child
            //This will be called when the first VC in the flow, controlled by this coordinator, leaves the navigation stack
            self.delegate?.didFinishFlow(for: self)
        })
    }
    
    override func toPresentable() -> UIViewController { firstVC }
}

// MARK: Navigation
extension DemoFlowCoordinator {
    private func goToSecondVC() {
        let secondVC = factories.secondVCFactory()
        secondVC.delegate = self
        router.push(secondVC, animated: true, completion: nil)
    }
    
    private func goToThirdVC() {
        let thirdVC = factories.thirdVCFactory()
        thirdVC.delegate = self
        router.push(thirdVC, animated: true, completion: nil)
    }
}

extension DemoFlowCoordinator: FirstViewControllerDelegate {
    func firstVCDidTapNext() {
        goToSecondVC()
    }
}

extension DemoFlowCoordinator: SecondViewControllerDelegate {
    func secondVCDidTapNext() {
        goToThirdVC()
    }
}

extension DemoFlowCoordinator: ThirdViewControllerDelegate {
    func thirdVCDidFinish() {
        router.popModule(for: self, animated: true) //Pops all vcs pushed by coordinator
    }
}
