//
//  Presentable.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

protocol Presentable {
    func toPresentable() -> UIViewController
}

extension UIViewController: Presentable {
    func toPresentable() -> UIViewController { self }
}
