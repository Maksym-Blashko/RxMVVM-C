//
//  TMDBMoviesRepository.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 07.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift

class TMDBMoviesRepository: MoviesRepository {
    let remoteAPI: MoviesRemoteAPI

    init(moviesAPI: MoviesRemoteAPI) {
        remoteAPI = moviesAPI
    }
    
    func getMyFavoriteMovies(page: Int) -> Single<TMDBMoviesPage> {
        remoteAPI.getFavoriteMovies(page: page)
    }
    
    func markAsFavorite(mediaID: Int, favorite: Bool) -> Single<OKResponse> {
        remoteAPI.markAsFavorite(mediaID: mediaID, favorite: favorite)
    }
    
    func getSimilarMovies(movieID: MovieID) -> Single<TMDBMoviesPage> {
        remoteAPI.getSimilarMovies(movieID: movieID, language: Language.english, page: 1)
    }
       
    deinit {
        print("im dead \(self)")
    }
    
}
