//
//  UIView + Extensions.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 04.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

// To Avoid known UIStackView bug (http://www.openradar.me/25087688)
extension UIView {
    var isHiddenInStackView: Bool {
        get { isHidden }
        set {
            if isHidden != newValue {
                isHidden = newValue
            }
        }
    }
}
