//
//  TMDBAuthRemoteAPI.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 06.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
typealias RequestToken = String

struct TMDBAuthRemoteAPI: AuthRemoteAPI {
    
    let router: APIRouter<Auth>
    let accountRouter: APIRouter<Account>
    let responseHandler: RemoteAPIResponseHandler
    let accountResponseHandler: RemoteAPIResponseHandler
    
    init(router: APIRouter<Auth>,
         accountRouter: APIRouter<Account>,
         responseHandler: RemoteAPIResponseHandler,
         accountResponseHandler: RemoteAPIResponseHandler) {
        self.accountRouter = accountRouter
        self.accountResponseHandler = accountResponseHandler
        self.router = router
        self.responseHandler = responseHandler
    }
    
    func delete(userSession: UserSession) -> Single<UserSession> {
        let theRouter = router
        let rHandler = responseHandler
        return Single.create { single -> Disposable in
            let apiKey = AppSettings.shared.apiKey
            let task = theRouter.request(.logout(apiKey: apiKey, sessionID: userSession.remoteSession.sessionID), responseHandler: rHandler) { (result: Result<OKResponse, Error>) in
                switch result {
                case .failure(let error):
                    single(.error(error))
                case .success:
                    single(.success(userSession))
                }
            }
            return Disposables.create { task?.cancel() }
        }.observeOn(MainScheduler.instance)
    }
    
    func getUserProfile(for remoteSession: RemoteUserSession) -> Single<UserProfile> {
        let theRouter = accountRouter
        let rHandler = accountResponseHandler
        return Single.create { single -> Disposable in
            let apiKey = AppSettings.shared.apiKey
            let task = theRouter.request(.getDetails(apiKey: apiKey, sessionID: remoteSession.sessionID), responseHandler: rHandler) { (result: Result<UserProfile, Error>) in
                switch result {
                case .failure(let error):
                    single(.error(error))
                case .success(let profile):
                    single(.success(profile))
                }
            }
            return Disposables.create { task?.cancel() }
        }.observeOn(MainScheduler.instance)
    }
    
    func createNewSession(with validationResult: ValidationResult) -> Single<RemoteUserSession> {
        let theRouter = router
        let rHandler = responseHandler
        return Single.create { single -> Disposable in
            let apiKey = AppSettings.shared.apiKey
            let task = theRouter.request(.createSession(apiKey: apiKey, requestToken: validationResult.requestToken), responseHandler: rHandler) { (result: Result<TMDBUserSession, Error>) in
                switch result {
                case .failure(let error):
                    single(.error(error))
                case .success(let session):
                   let remoteSession = RemoteUserSession(sessionID: session.sessionId)
                   single(.success(remoteSession))
                }
            }
            return Disposables.create { task?.cancel() }
        }.observeOn(MainScheduler.instance)
    }
    
    func validateToken(userName: String, password: String, requestToken: RequestToken) -> Single<ValidationResult> {
        let theRouter = router
        let rHandler = responseHandler
        return Single.create { single -> Disposable in
            let apiKey = AppSettings.shared.apiKey
            let task = theRouter.request(.validate(userName: userName,
                                                   password: password,
                                                   requestToken: requestToken,
                                                   apiKey: apiKey),
                                         responseHandler: rHandler) { (result: Result<TMDBToken, Error>) in
                switch result {
                case .failure(let error):
                    single(.error(error))
                case .success(let token):
                   let result = ValidationResult(userName: userName, requestToken: token.requestToken)
                   print("[Auth] validate token success -> \(result)")
                   single(.success(result))
                }
            }
            return Disposables.create { task?.cancel() }
        }.observeOn(MainScheduler.instance)
    }
    
    func createRequestToken() -> Single<TMDBToken> {
        let theRouter = router
        let rHandler = responseHandler
        return Single.create { single -> Disposable in
            let apiKey = AppSettings.shared.apiKey
            let task = theRouter.request(.createRequestToken(TMDBKey: apiKey), responseHandler: rHandler) { (result: Result<TMDBToken, Error>) in
                switch result {
                case .failure(let error):
                    single(.error(error))
                case .success(let token):
                    single(.success(token))
                }
            }
            return Disposables.create { task?.cancel() }
        }.observeOn(MainScheduler.instance)
    }
}

struct ValidationResult {
    let userName: String
    let requestToken: String
}

struct TMDBUserSession: Codable {
    let sessionId: String
}
