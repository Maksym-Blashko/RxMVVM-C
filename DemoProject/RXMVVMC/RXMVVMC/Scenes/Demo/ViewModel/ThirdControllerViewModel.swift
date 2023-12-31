//
//  ThirdControllerViewModel.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 10.12.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ThirdControllerViewModeling: class {
    // MARK: - Input
    var finishTap: AnyObserver<Void> { get }
    // MARK: - Output
    var countdown: Observable<String>! { get }
    var close: Observable<Void>! { get }
}

class ThirdControllerViewModel: ThirdControllerViewModeling {
    // MARK: - Properties
    // MARK: - Factories
    // MARK: - Subjects
    private let _finishTap = PublishSubject<Void>()
    // MARK: - Input
    var finishTap: AnyObserver<Void> { _finishTap.asObserver() }
    // MARK: - Output
    var countdown: Observable<String>!
    var close: Observable<Void>!
    // MARK: - Methods
    
    init() {
        bindOutput()
    }
    
    private func bindOutput() {
        let seconds = 3
        countdown = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .skipUntil(_finishTap)
            .scan(seconds + 1) { accumulator, _ -> Int in accumulator - 1 }
            .map { String($0) }.debug("Timer", trimOutput: false)
            .share()
        
        close = countdown.skip(seconds).map { _ in return }
    }
}
