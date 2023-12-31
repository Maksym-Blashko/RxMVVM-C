//
//  APIErrors.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 07.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

// MARK: - Auth
struct AuthRemoteAPIError: Error {
    private let message: String
    init(statusCode: Int, data: Data?) {
        switch statusCode {
        case 401:
            message = "Authentication failed."
        case 404:
            message = "The resource you requested could not be found."
        default:
            guard let data = data else {
                message = "Something went wrong, please try again later"
                return
            }
            do {
                message = try data.decodeTo(type: TMDBError.self).statusMessage ?? "Something went wrong, please try again later"
            } catch let error {
                message = error.localizedDescription
            }
        }
    }
    
    init(message: String) {
        self.message = message
    }
    
    static let wrongCredentials: AuthRemoteAPIError = {
        AuthRemoteAPIError(message: "Wrong credentials")
    }()
}

extension AuthRemoteAPIError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}

// MARK: - Account
struct AccountRemoteAPIError: Error {
    private let message: String
    init(statusCode: Int, data: Data?) {
        guard let data = data else {
            message = "Something went wrong, please try again later"
            return
        }
        do {
            message = try data.decodeTo(type: TMDBError.self).statusMessage ?? "Something went wrong, please try again later"
        } catch let error {
            message = error.localizedDescription
        }
    }
    
    init(message: String) {
        self.message = message
    }
}
extension AccountRemoteAPIError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}

struct MoviesRemoteAPIError: Error {
    private let message: String
    init(statusCode: Int, data: Data?) {
        guard let data = data else {
            message = "Something went wrong, please try again later"
            return
        }
        do {
            message = try data.decodeTo(type: TMDBError.self).statusMessage ?? "Something went wrong, please try again later"
        } catch let error {
            message = error.localizedDescription
        }
    }
}

extension MoviesRemoteAPIError: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
