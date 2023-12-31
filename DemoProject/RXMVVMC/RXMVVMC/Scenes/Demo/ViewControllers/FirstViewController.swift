//
//  FirstViewController.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 10.12.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

//FOR ROUTING COORDINATION DEMO PURPOSES ONLY!!!
protocol FirstViewControllerDelegate: class {
    func firstVCDidTapNext()
}

class FirstViewController: UIViewController {
    weak var delegate: FirstViewControllerDelegate?
    
    @IBAction private func didTapNext(sender: UIButton) {
        delegate?.firstVCDidTapNext()
    }
}
