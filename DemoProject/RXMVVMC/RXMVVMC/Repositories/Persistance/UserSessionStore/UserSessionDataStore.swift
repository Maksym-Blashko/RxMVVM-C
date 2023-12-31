//
//  UserSessionDataStore.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

/**
 Manages the persistance of the UserSession.
 */
protocol UserSessionDataStore {
    ///Reads the session from the  storage and emits it into the stream if it exists, otherwise - emits nil.
    func readUserSession() -> Single<UserSession?>
    ///Saves the new session to the storage and emits it into the stream after the successful writing. If writing fails - emits  an error.
    func save(userSession: UserSession) -> Single<UserSession>
    ///Deletes the session from the storage and emits it into the stream. If deletion fails - emits  an error.
    func delete(userSession: UserSession) -> Single<UserSession>
}
