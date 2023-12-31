//
//  SecondViewController.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 10.12.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

//FOR ROUTING COORDINATION DEMO PURPOSES ONLY!!!
protocol SecondViewControllerDelegate: class {
    func secondVCDidTapNext()
}

class SecondViewController: UIViewController {
    weak var delegate: SecondViewControllerDelegate?
    
    @IBAction private func didTapNext(sender: UIButton) {
        delegate?.secondVCDidTapNext()
    }
}
