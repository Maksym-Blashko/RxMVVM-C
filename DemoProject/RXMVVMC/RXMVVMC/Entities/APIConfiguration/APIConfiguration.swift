//
//  APIConfiguration.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 17.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

struct APIConfiguration: Codable {
    let images: ImagesConfiguration
    
    static var defaultConfig: APIConfiguration {
        let imagesDefaultConfig = ImagesConfiguration(baseUrl: "http://image.tmdb.org/t/p/",
                                                      secureBaseUrl: "https://image.tmdb.org/t/p/",
                                                      backdropSizes: ["w300", "w780","w1280","original"],
                                                      logoSizes: ["w45","w92","w154", "w185", "w300", "w500", "original"],
                                                      posterSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
                                                      profileSizes: ["w45", "w185", "h632", "original"])
        return APIConfiguration(images: imagesDefaultConfig)
    }
}

///Represents the base info for building  image urls
struct ImagesConfiguration: Codable {
    let baseUrl: String
    let secureBaseUrl: String
    let backdropSizes: [String]
    let logoSizes: [String]
    let posterSizes: [String]
    let profileSizes: [String]
}
