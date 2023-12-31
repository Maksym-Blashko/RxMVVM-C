//
//  UserSessionRepository.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

///Manages all interactions related to the user session.
protocol UserSessionRepository {
    /// Reads the saved userSession
    /// - Returns: stream which emits the user session if exists, otherwise returns nil
    func readUserSession() -> Single<UserSession?>
    
    /// Fetches the updated user profile
    /// - Returns: stream which emits the refreshed user profile or error.
    func refreshProfile() -> Single<UserProfile>
    
    /// Gets the new user session for provided credentials
    /// - Returns: stream which emits the new user session, or error
    func signIn(userName: String, password: String) -> Single<UserSession>
    
    /// Deletes the current user session
    ///  - Returns: stream which emits the deleted user session, or error
    func signOut(userSession: UserSession) -> Single<UserSession>
    func signUp(newAccount: NewAccount) -> Single<UserSession>
}

/**
 Conceptual object that represents the current "user session"
 Consists of user profile and remoteSession.
 */
struct UserSession: Codable {
    let profile: UserProfile
    let remoteSession: RemoteUserSession
    
    init(profile: UserProfile, remoteSession: RemoteUserSession) {
        self.profile = profile
        self.remoteSession = remoteSession
    }
}

extension UserSession: Equatable {
    public static func == (lhs: UserSession, rhs: UserSession) -> Bool {
        return lhs.profile == rhs.profile &&
            lhs.remoteSession == rhs.remoteSession
    }
}

struct UserProfile: Equatable, Codable {
    let id: Int
    let name: String
    let username: String
    let includeAdult: Bool
    
    public static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id
    }
}
