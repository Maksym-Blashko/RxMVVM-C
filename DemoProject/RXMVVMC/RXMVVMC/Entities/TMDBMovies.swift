//
//  TMDBMovies.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 07.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

protocol PosterPresentable {
    var posterPath: String? { get }
}

protocol Movie: PosterPresentable {
    var title: String { get }
    var originalTitle: String { get }
    var id: Int { get }
    var overview: String? { get }
    var releaseDate: String { get }
    var originalLanguage: String { get }
}

struct TMDBMoviesPage: Codable {
    let page: Int
    let results: [TMDBMovie]
    let totalPages: Int
    let totalResults: Int
}

struct TMDBMovie: Codable, Movie {
    let adult: Bool
    let overview: String?
    let releaseDate: String
    let genreIds: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let popularity: Double
    let voteCount: Int
    let voteAverage: Double
    let video: Bool
    let posterPath: String?
}
