//
//  AuthRemoteAPI.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthRemoteAPI {
    func delete(userSession: UserSession) -> Single<UserSession>
    func createRequestToken() -> Single<TMDBToken>
    func validateToken(userName: String, password: String, requestToken: RequestToken) -> Single<ValidationResult>
    func createNewSession(with validationResult: ValidationResult) -> Single<RemoteUserSession>
    func getUserProfile(for remoteSession: RemoteUserSession) -> Single<UserProfile>
}

enum NetworkingError: Error {
    case noData
}
