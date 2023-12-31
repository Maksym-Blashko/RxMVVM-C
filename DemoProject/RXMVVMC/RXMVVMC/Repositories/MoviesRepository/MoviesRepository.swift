//
//  MoviesRepository.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 07.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
///Manages all interactions related to the movies.
protocol MoviesRepository {
    ///Fetches the favorite movies page
    /// - Parameter page: Page to fetch
    /// - Returns: Stream which emits the favorite movie pages, or error
    func getMyFavoriteMovies(page: Int) -> Single<TMDBMoviesPage>
    ///Sets the movies favorite status
    /// - Parameters:
    ///     - mediaID: Id of the movie for  which you  want to change the "favorite" status
    ///     - favorite: Bool for isFavorite status
    /// - Returns:
    ///   Stream which emits OKResponse if succeed, otherwise emits error.
    func markAsFavorite(mediaID: MovieID, favorite: Bool) -> Single<OKResponse>
    ///Fetches the similar movies
    /// - Parameters:
    ///     - movieID: Id of the movie for  which you  want to find the similar movies
    /// - Returns: Stream which emits the similar movie pages, or error
    func getSimilarMovies(movieID: MovieID) -> Single<TMDBMoviesPage>
}
