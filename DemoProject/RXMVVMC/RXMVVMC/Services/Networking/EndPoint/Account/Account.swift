//
//  Account.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 06.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

struct MarkAsFavoriteRequestBody: Codable {
    let mediaType: String
    let mediaId: Int
    let favorite: Bool
}

enum Account: EndPointType {
    case getDetails(apiKey: String, sessionID: String)
    case getFavoriteMovies(apiKey: String, accountID: Int, sessionID: String, page: Int)
    case markAsFavorite(accountID: Int, apiKey: String, sessionID: String, body: MarkAsFavoriteRequestBody)
}

extension Account {
    var environmentBaseURL: String { "https://api.themoviedb.org/3/" }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("failed to configure base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getDetails: return "account"
        case .getFavoriteMovies(_ , let accountID, _, _):
            return "account/\(accountID)/favorite/movies"
        case .markAsFavorite(let accountID, _, _, _):
            return "account/\(accountID)/favorite"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getDetails, .getFavoriteMovies:
            return .get
        case .markAsFavorite:
           return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getDetails(let apiKey, let sessionID):
            return .requestParameters(bodyParameters: nil, urlParameters: ["api_key": apiKey,
                                                                           "session_id": sessionID])
        case .getFavoriteMovies(let apiKey, _, let sessionID, let page):
            return .requestParameters(bodyParameters: nil, urlParameters: ["api_key": apiKey,
                                                                           "session_id": sessionID,
                                                                           "page": page])
        case .markAsFavorite(_, let apiKey, let sessionID, let body):
            return .requestParameters(bodyParameters: body.toDictionary(),
                                      urlParameters: ["api_key": apiKey,
                                                      "session_id": sessionID])
        }
    }
    
    var headers: HTTPHeaders? { nil }
}
