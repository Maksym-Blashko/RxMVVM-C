//
//  ThirdViewController.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 10.12.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

//FOR ROUTING COORDINATION DEMO PURPOSES ONLY!!!
protocol ThirdViewControllerDelegate: class {
    func thirdVCDidFinish()
}

class ThirdViewController: UIViewController {
    @IBOutlet private weak var finishButton: UIButton!
    @IBOutlet private weak var label: UILabel!
    weak var delegate: ThirdViewControllerDelegate?
    // MARK: Outlets
    
    // MARK: Properties
    var viewModel: ThirdControllerViewModeling!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
    }
    
    // MARK: Methods
    func bind(to viewModel: ThirdControllerViewModeling) {
        rx.disposeBag.insert(
            // MARK: VM Inputs
            finishButton.rx.tap.take(1).bind(to: viewModel.finishTap),
            // MARK: VM Outputs
            viewModel.countdown.subscribe(onNext: { [weak self] string in
                self?.label.text = string
            }),
            viewModel.close.subscribe(onNext: { [weak self] _ in
                self?.delegate?.thirdVCDidFinish()
            })
        )
    }
}
