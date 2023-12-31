//
//  MyProfileControllerViewModel.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyProfileViewModeling: class {
    // MARK: - Input
    var logoutTap: AnyObserver<Void> { get }
    
    // MARK: - Output
    var userSession: Observable<UserSessionDisplayModel>! { get }
    var isLoading: Driver<Bool>! { get }
    var didLogout: Driver<Bool>! { get }
    var errors: Driver<String>! { get }
}

class MyProfileControllerViewModel: MyProfileViewModeling {

    // MARK: - Properties
    private let sessionRepository: UserSessionRepository

    // MARK: - Subjects
     private let _logoutTap = PublishSubject<Void>()

    // MARK: - Input
    var logoutTap: AnyObserver<Void> { _logoutTap.asObserver() }

    // MARK: - Output
    var userSession: Observable<UserSessionDisplayModel>!
    var didLogout: Driver<Bool>!
    var isLoading: Driver<Bool>!
    var errors: Driver<String>!

    // MARK: - Methods
    init(userSessionRepository: UserSessionRepository) {
        sessionRepository = userSessionRepository
        bindOutput()
    }

    private func bindOutput() {
        let logoutRequest = _logoutTap.flatMapLatest {[unowned self] _  in self.logout() }.share()
        didLogout = logoutRequest.compactMap { $0.element }.map { _ in true }.asDriver(onErrorJustReturn: false)
        let logoutError = logoutRequest.compactMap { $0.error }.map { $0.localizedDescription }
        errors = Observable<String>.merge(logoutError).asDriver(onErrorJustReturn: "")
        isLoading = Observable<Bool>.merge(_logoutTap.map { true }, logoutRequest.map { _ in false })
            .asDriver(onErrorJustReturn: false)
        
        userSession = sessionRepository.readUserSession()
            .asObservable()
            .compactMap { $0 }
            .map { session -> UserSessionDisplayModel in
                UserSessionDisplayModel(userID: "\(session.profile.id)",
                    userName: session.profile.name,
                    sessionID: session.remoteSession.sessionID)
            }
            .observeOn(MainScheduler.instance)
    }

    private func logout() -> Observable<Event<UserSession>> {
        let repo = sessionRepository
        return repo.readUserSession()
            .asObservable()
            .compactMap { $0 }
            .flatMap { session -> Observable<Event<UserSession>> in
                repo.signOut(userSession: session).asObservable().materialize()
        }
    }
}


struct UserSessionDisplayModel {
    let userID: String
    let userName: String
    let sessionID: String
}
