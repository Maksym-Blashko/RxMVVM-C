//
//  UDUserDataSession.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 06.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

class UDUserDataSession: UserSessionDataStore {
    @UDStorage(key: "rxmvvmc.usersession", defaultValue: nil)
    var userSession: UserSession?
    
    func readUserSession() -> Single<UserSession?> {
        Single.deferred {[weak self] in Single.just(self?.userSession)  }
    }
    
    func save(userSession: UserSession) -> Single<UserSession> {
        Single<UserSession>.create {[weak self] single -> Disposable in
            self?.userSession = userSession
            single(.success(userSession))
            return Disposables.create()
        }
    }
    
    func delete(userSession: UserSession) -> Single<UserSession> {
        Single<UserSession>.create {[weak self] single -> Disposable in
            self?.userSession = nil
            single(.success(userSession))
            return Disposables.create()
        }
    }
}
