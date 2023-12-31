//
//  Movies.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 21.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

enum Movies: EndPointType {
    case getSimilarMovies(mediaID: Int, apiKey: String, language: String, page: Int)
}

extension Movies {
    var environmentBaseURL: String { "https://api.themoviedb.org/3/" }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("failed to configure base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getSimilarMovies(let movieID, _, _, _):
            return "movie/\(movieID)/similar"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getSimilarMovies:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getSimilarMovies(_, let apiKey, let language, let page):
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: ["api_key": apiKey,
                                                      "language": language,
                                                      "page": page])
        }
    }
    
    var headers: HTTPHeaders? { nil }
}
