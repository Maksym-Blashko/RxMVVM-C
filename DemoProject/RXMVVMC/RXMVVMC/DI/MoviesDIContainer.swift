//
//  MoviesDIContainer.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import Swinject
import RxSwift
//It's ok to supress linter here.
//swiftlint:disable force_unwrapping

class MoviesDIContainer {
    private let container: Container
    
    init(parentContainer: Container) {
        container = Container(parent: parentContainer) { container in
            // MARK: MoviesList
            container.register(FavoriteMoviesDataProvider.self) { resolver -> FavoriteMoviesDataProvider in
                FavoriteMoviesDataProvider(moviesRepository: resolver.resolve(MoviesRepository.self)!)
            }
            
            container.register(MoviesListViewModeling.self) { resolver in
                MovieListControllerViewModel(dataProvider: resolver.resolve(FavoriteMoviesDataProvider.self)!,
                                             moviesRepository: resolver.resolve(MoviesRepository.self)!,
                                             beConfigurationRepository: resolver.resolve(BEConfigurationRepository.self)!)
            }
            
            container.register(MoviesListViewController.self) { resolver -> MoviesListViewController in
                let sb = UIStoryboard(.movies)
                let vc: MoviesListViewController = sb.instantiateViewController()
                vc.viewModel = resolver.resolve(MoviesListViewModeling.self)!
                vc.tabBarItem.image = #imageLiteral(resourceName: "tickets_unselected")
                vc.tabBarItem.selectedImage = #imageLiteral(resourceName: "tickets_selected")
                vc.tabBarItem.title = "Movies"
                vc.navigationItem.title = "Favorite movies"
                return vc
            }
            // MARK: SimilarMovies
            container.register(SimilarMoviesControllerViewModeling.self) { (resolver, movieID: MovieID) -> SimilarMoviesControllerViewModeling in
                SimilarMoviesControllerViewModel(movieID: movieID,
                                                 moviesRepository: resolver.resolve(MoviesRepository.self)!,
                                                 beConfigRepository: resolver.resolve(BEConfigurationRepository.self)!)
            }
            
            container.register(SimilarMoviesViewController.self) { (_ , viewModel: SimilarMoviesControllerViewModeling) -> SimilarMoviesViewController in
                let sb = UIStoryboard(.movies)
                let vc: SimilarMoviesViewController = sb.instantiateViewController()
                vc.viewModel = viewModel
                return vc
            }
            
            // MARK: MovieDetails
            container.register(MovieDetailControllerViewModeling.self) { (resolver, movie: TMDBMovie) -> MovieDetailControllerViewModeling in
                let factory: (MovieID) -> SimilarMoviesViewController = { id in
                    let vm = resolver.resolve(SimilarMoviesControllerViewModeling.self, argument: movie.id)!
                    let vc = resolver.resolve(SimilarMoviesViewController.self, argument: vm)!
                    return vc
                }
                return MovieDetailControllerViewModel(movie: movie,
                                               beConfiguration: resolver.resolve(BEConfigurationRepository.self)!, similarMoviesModuleFactory: factory)
            }
            
            container.register(MovieDetailsViewController.self) { (resolver, movie: TMDBMovie) -> MovieDetailsViewController in
                let sb = UIStoryboard(.movies)
                let vc: MovieDetailsViewController = sb.instantiateViewController()
                vc.viewModel = resolver.resolve(MovieDetailControllerViewModeling.self, argument: movie)!
                return vc
            }
            // MARK: Coordinator
            container.register(MoviesCoordinator.self) { resolver -> MoviesCoordinator in
                let navVC = UINavigationController()
                navVC.navigationBar.isTranslucent = true
                let router = Router(navigationController: navVC)
                let moveisListVCFactory: () -> MoviesListViewController = {
                    resolver.resolve(MoviesListViewController.self)!
                }
                let moviesDetailsVCFactory: (TMDBMovie) -> MovieDetailsViewController = { movie in
                    resolver.resolve(MovieDetailsViewController.self, argument: movie)!
                }
                return MoviesCoordinator(router: router,
                                         moviesListVCFactory: moveisListVCFactory,
                                         movieDetailsVCFactory: moviesDetailsVCFactory)
            }
        }
    }
    
    func makeMoviesCoordinator() -> MoviesCoordinator { container.resolve(MoviesCoordinator.self)!
    }
}
