//
//  FakeAuthRemoteAPI.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct FakeAuthRemoteAPI: AuthRemoteAPI {
    func createRequestToken() -> Single<TMDBToken> {
        Single.just(TMDBToken(success: true,
                              expiresAt: "2016-08-26 17:04:39 UTC",
                              requestToken: "ff5c7eeb5a8870efe3cd7fc5c282cffd26800ecd"))
            .delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    func validateToken(userName: String, password: String, requestToken: RequestToken) -> Single<ValidationResult> {
        guard userName == "vshkliar", password == "Qwerty123" else {
           return Single.error(AuthRemoteAPIError.wrongCredentials).observeOn(MainScheduler.instance)
        }
        return Single.just(ValidationResult(userName: userName,
                                     requestToken: "fake5c7eeb5a8870efe3cd7fc5c282cffd26800ecd"))
            .delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    func createNewSession(with validationResult: ValidationResult) -> Single<RemoteUserSession> {
        Single.just(RemoteUserSession(sessionID: "fafafafafaf"))
            .delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    func getUserProfile(for remoteSession: RemoteUserSession) -> Single<UserProfile> {
        let profile = UserProfile(id: 0, name: "Fake", username: "Fake", includeAdult: false)
        return Single.just(profile).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    func delete(userSession: UserSession) -> Single<UserSession> {
        Single.just(userSession)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
