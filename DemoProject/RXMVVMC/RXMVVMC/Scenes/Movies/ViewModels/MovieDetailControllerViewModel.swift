//
//  MovieDetailControllerViewModel.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 20.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
typealias MovieID = Int
protocol MovieDetailControllerViewModeling: class {
    // MARK: - Input
    // MARK: - Output
    var title: String { get }
    var overview: String { get }
    var imageURL: URL? { get }
    var similarMoviesModule: SimilarMoviesViewController { get }
}

class MovieDetailControllerViewModel: MovieDetailControllerViewModeling {
    // MARK: - Properties
    // MARK: - Factories
    // MARK: - Subjects
    // MARK: - Input
    // MARK: - Output
    let title: String
    let overview: String
    let imageURL: URL?
    let similarMoviesModule: SimilarMoviesViewController
    
    // MARK: - Methods
    init(movie: TMDBMovie,
         beConfiguration: BEConfigurationRepository,
         similarMoviesModuleFactory: (MovieID) -> SimilarMoviesViewController) {
        similarMoviesModule = similarMoviesModuleFactory(movie.id)
        let imgConfig = beConfiguration.currentBEConfiguration.images
        title = movie.originalTitle
        overview = movie.overview ?? "No overview available"
        imageURL = URL(string: "\(imgConfig.secureBaseUrl)\(imgConfig.posterSizes.last ?? "original")\(movie.posterPath ?? "")")
        bindOutput()
    }

    private func bindOutput() {

    }
}
