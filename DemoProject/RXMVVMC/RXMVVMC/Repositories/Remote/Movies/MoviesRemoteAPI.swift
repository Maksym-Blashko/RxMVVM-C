//
//  MoviesRemoteAPI.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 07.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

protocol MoviesRemoteAPI {
    func getFavoriteMovies(page: Int) -> Single<TMDBMoviesPage>
    func getSimilarMovies(movieID: Int, language: Language, page: Int) -> Single<TMDBMoviesPage>
    func markAsFavorite(mediaID: Int, favorite: Bool) -> Single<OKResponse>
}

enum Language {
    case english
    case russian
    var code: String {
        switch self {
        case .english:
            return "en-UK"
        case .russian:
            return "ru-RU"
        }
    }
}
