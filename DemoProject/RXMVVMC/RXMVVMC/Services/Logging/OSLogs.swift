//
//  OSLogs.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 11.12.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import os.log

enum LogCategory: String {
    case userSession = "[UserSession]"
    case network = "[Network]"
}

extension OSLog {
    private static var subsystem: String { Bundle.main.bundleIdentifier ?? "" }
    // MARK: Logs
    static let userSession = OSLog(subsystem: subsystem, category: LogCategory.userSession.rawValue)
    static let network = OSLog(subsystem: subsystem, category: LogCategory.network.rawValue)
}
