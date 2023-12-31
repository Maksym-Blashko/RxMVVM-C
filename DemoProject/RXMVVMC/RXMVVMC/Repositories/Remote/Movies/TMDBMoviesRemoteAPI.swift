//
//  TMDBMoviesRemoteAPI.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 07.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct TMDBMoviesRemoteAPI: MoviesRemoteAPI {
    private let accRouter: APIRouter<Account>
    private let moviesRouter: APIRouter<Movies>
    private let accResponseHandler: RemoteAPIResponseHandler
    private let moviesResponseHandler: RemoteAPIResponseHandler
    private let userSessionDataStore: UserSessionDataStore
    
    init(accountRouter: APIRouter<Account>,
         moviesRouter: APIRouter<Movies>,
         accResponseHandler: RemoteAPIResponseHandler,
         movieResonseHandler: RemoteAPIResponseHandler,
         userSessionDataStore: UserSessionDataStore) {
        self.accRouter = accountRouter
        self.moviesRouter = moviesRouter
        self.accResponseHandler = accResponseHandler
        self.moviesResponseHandler = movieResonseHandler
        self.userSessionDataStore = userSessionDataStore
    }
    
    func getFavoriteMovies(page: Int) -> Single<TMDBMoviesPage> {
        let getMovies = getFavMovies
        return userSession().flatMap { session -> Single<TMDBMoviesPage> in
            getMovies(session, page)
        }.observeOn(MainScheduler.instance)
    }
    
    func markAsFavorite(mediaID: Int, favorite: Bool) -> Single<OKResponse> {
        let markAsFavoriteFunc = mark
        return userSession().flatMap { session -> Single<OKResponse> in
            markAsFavoriteFunc(mediaID, favorite, session)
        }.observeOn(MainScheduler.instance)
    }
    
    func getSimilarMovies(movieID: Int, language: Language, page: Int) -> Single<TMDBMoviesPage> {
        let router = moviesRouter
        let handler = moviesResponseHandler
        return Single.create { single -> Disposable in
            let apiKey = AppSettings.shared.apiKey
            let task = router.request(.getSimilarMovies(mediaID: movieID, apiKey: apiKey, language: language.code, page: page), responseHandler: handler) { (result: Result<TMDBMoviesPage, Error>) in
                switch result {
                case .failure(let error):
                    single(.error(error))
                case .success(let page):
                    single(.success(page))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }.observeOn(MainScheduler.instance)
    }
    
    private func mark(mediaWith mediaID: Int, favorite: Bool, userSession: UserSession) -> Single<OKResponse> {
        let router = accRouter
        let handler = accResponseHandler
        return Single.create { single -> Disposable in
            let apiKey = AppSettings.shared.apiKey
            let body = MarkAsFavoriteRequestBody(mediaType: "movie", mediaId: mediaID, favorite: favorite)
            let task = router.request(.markAsFavorite(accountID: userSession.profile.id,  apiKey: apiKey, sessionID: userSession.remoteSession.sessionID, body: body),
                                      responseHandler: handler) { (result: Result<OKResponse, Error>) in
                                        switch result {
                                        case .failure(let error):
                                            single(.error(error))
                                        case .success(let response):
                                            single(.success(response))
                                        }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    private func getFavMovies(for userSession: UserSession, page: Int) -> Single<TMDBMoviesPage> {
        let router = accRouter
        let handler = accResponseHandler
        return Single.create { single -> Disposable in
            let apiKey = AppSettings.shared.apiKey
            let task = router.request(.getFavoriteMovies(apiKey: apiKey, accountID: userSession.profile.id, sessionID: userSession.remoteSession.sessionID, page: page),
                                      responseHandler: handler) { (result: Result<TMDBMoviesPage, Error>) in
                                        switch result {
                                        case .failure(let error):
                                            single(.error(error))
                                        case .success(let page):
                                            single(.success(page))
                                        }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    private func userSession() -> Single<UserSession> {
        userSessionDataStore.readUserSession()
            .map { session -> UserSession in
                guard let session = session else {
                    throw AccountRemoteAPIError(message: "Not valid session")
                }
                return session
        }
    }
}

struct OKResponse: Decodable {}
