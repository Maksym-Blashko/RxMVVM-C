//
//  BEConfiguration.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 17.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

enum BEConfiguration: EndPointType {
    case getApiConfig(apiKey: String)
}

extension BEConfiguration {
    var environmentBaseURL: String { "https://api.themoviedb.org/3/"}
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("failed to configure base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getApiConfig:
            return "configuration"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getApiConfig:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getApiConfig(let apiKey):
            return .requestParameters(bodyParameters: nil, urlParameters: ["api_key": apiKey])
        }
    }
    
    var headers: HTTPHeaders? { nil }
}
