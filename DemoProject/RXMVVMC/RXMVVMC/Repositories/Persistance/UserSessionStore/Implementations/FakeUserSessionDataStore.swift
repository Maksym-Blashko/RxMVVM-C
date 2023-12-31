//
//  FakeUserSessionDataStore.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

class FakeUserSessionDataStore: UserSessionDataStore {
    
    // MARK: - Properties
    var hasToken: Bool
    
    // MARK: - Methods
    init(hasToken: Bool) {
        self.hasToken = hasToken
    }
    
    func save(userSession: UserSession) -> Single<UserSession> {
        hasToken = true
        return Single.just(userSession)
    }
    
    func readUserSession() -> Single<UserSession?> {
        switch hasToken {
        case true:
           return simulateHasToken()
        case false:
            return simulateNoToken()
        }
    }
    
    func delete(userSession: UserSession) -> Single<UserSession> {
        Single.just(userSession).delaySubscription(.milliseconds(400), scheduler: MainScheduler.instance)
    }
    
    private func simulateHasToken() -> Single<UserSession?> {
        let profile =  UserProfile(id: 0, name: "test", username: "testUserName", includeAdult: false)
        let session = RemoteUserSession(sessionID: "123")
        return Single.just(UserSession(profile: profile, remoteSession: session))
    }
    
    private func simulateNoToken() -> Single<UserSession?> { Single.just(nil) }
}
