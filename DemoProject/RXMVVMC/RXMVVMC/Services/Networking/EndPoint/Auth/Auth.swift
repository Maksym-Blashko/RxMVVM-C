//
//  Auth.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 06.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

enum Auth: EndPointType {
    ///Create a temporary request token that can be used to validate a TMDb user login.
    case createRequestToken(TMDBKey: String)
    ///This method allows an application to validate a request token by entering a username and password.
    case validate(userName: String, password: String, requestToken: String, apiKey: String)
    ///Method to create a fully valid session ID once a user has validated the request token.
    case createSession(apiKey: String, requestToken: String)
    ///Deletes user ssession.
    case logout(apiKey: String, sessionID: String)
}

extension Auth {
    var environmentBaseURL: String {
        //You can do env check and tweak url here
        return "https://api.themoviedb.org/3/authentication/"
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("failed to configure base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .createRequestToken:
            return "token/new"
        case .validate:
            return "token/validate_with_login"
        case .createSession:
            return "session/new"
        case .logout:
            return "session"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .createRequestToken:
            return .get
        case .validate, .createSession:
            return .post
        case .logout:
            return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .createRequestToken(let TMDBKey):
            return .requestParameters(bodyParameters: nil, urlParameters: ["api_key": TMDBKey])
        case .validate(let userName, let password, let requestToken, let apiKey):
            let params = ["username": userName,
                          "password": password,
                          "request_token": requestToken]
            return .requestParameters(bodyParameters: params,
                                      urlParameters: ["api_key": apiKey])
        case .createSession(let apiKey, let requestToken):
            return .requestParameters(bodyParameters: ["request_token": requestToken],
            urlParameters: ["api_key": apiKey])
        case .logout(let apiKey, let sessionID):
            return .requestParameters(bodyParameters: ["session_id": sessionID],
                                urlParameters: ["api_key": apiKey])
        }
    }
    
    var headers: HTTPHeaders? { nil }
}
