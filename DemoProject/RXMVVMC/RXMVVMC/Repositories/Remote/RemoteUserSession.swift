//
//  RemoteUserSession.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 01.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
typealias SessionID = String

///Represents the user's  API access
struct RemoteUserSession: Codable {
    let sessionID: SessionID
}

extension RemoteUserSession: Equatable {
    public static func == (lhs: RemoteUserSession, rhs: RemoteUserSession) -> Bool {
        return lhs.sessionID == rhs.sessionID
    }
}
