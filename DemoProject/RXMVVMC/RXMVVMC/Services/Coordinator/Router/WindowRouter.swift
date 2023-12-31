//
//  WindowRouter.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

protocol WindowRouterType: class {
    var window: UIWindow { get }
    init(window: UIWindow)
    func setRootModule(_ module: Presentable)
}

final class WindowRouter: NSObject, WindowRouterType {
    
    unowned let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    func setRootModule(_ module: Presentable) {
        let viewController = module.toPresentable()
        window.rootViewController = viewController
    }
}
