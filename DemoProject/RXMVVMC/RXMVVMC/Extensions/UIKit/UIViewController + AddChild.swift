//
//  UIViewController + AddChild.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 21.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController, to view: UIView) {
        self.addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        child.didMove(toParent: self)
    }
}
