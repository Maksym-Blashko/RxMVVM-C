//
//  UIViewController + Extensions.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 04.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
extension UIViewController {
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
