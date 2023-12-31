//
//  TMDBUserSessionRepository.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift


class TMDBUserSessionRepository: UserSessionRepository {
    
    let dataStore: UserSessionDataStore
    let remoteAPI: AuthRemoteAPI
    
    init(dataStore: UserSessionDataStore, remoteAPI: AuthRemoteAPI) {
        self.dataStore = dataStore
        self.remoteAPI = remoteAPI
    }
    
    func readUserSession() -> Single<UserSession?> { dataStore.readUserSession() }
    
    func refreshProfile() -> Single<UserProfile> {
        let api = remoteAPI
        let store = dataStore
        return getSavedSession().flatMap { session -> Single<UserSession> in
            api.getUserProfile(for: session.remoteSession)
                .map { profile -> UserSession in
                    UserSession(profile: profile, remoteSession: session.remoteSession)
            }
        }.flatMap { session in
            store.save(userSession: session)
        }.map { $0.profile }
    }
    
    func signUp(newAccount: NewAccount) -> Single<UserSession> {
        let store = dataStore
        return signIn(userName: newAccount.name, password: newAccount.password)
            .flatMap { session in
                store.save(userSession: session)
        }
    }
    
    // - creates the request token
    // - validates newly created request token
    // - creates the new session
    // - gets the user profile
    // - creates the UserSession obj
    // - saves it
    func signIn(userName: String, password: String) -> Single<UserSession> {
        let api = remoteAPI
        let store = dataStore
        return api.createRequestToken().flatMap { token -> Single<ValidationResult> in
            api.validateToken(userName: userName, password: password, requestToken: token.requestToken)
        }.flatMap { result -> Single<RemoteUserSession> in
            api.createNewSession(with: result)
        }.flatMap { remoteSession -> Single<UserSession> in
            api.getUserProfile(for: remoteSession)
                .map { profile -> UserSession in
                    UserSession(profile: profile, remoteSession: remoteSession)
            }
        }.flatMap { session in
            store.save(userSession: session)
        }
    }
    
    func signOut(userSession: UserSession) -> Single<UserSession> {
        let store = dataStore
        return remoteAPI.delete(userSession: userSession)
            .flatMap { session -> Single<UserSession> in
                store.delete(userSession: session)
        }
    }
    
    private func getSavedSession() -> Single<UserSession> {
        dataStore.readUserSession().map { session -> UserSession
            in
            guard let session = session else { throw AccountRemoteAPIError.init(message: "Session is not valid") }
            return session
        }
    }
}
