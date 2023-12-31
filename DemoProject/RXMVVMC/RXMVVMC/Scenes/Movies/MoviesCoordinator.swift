//
//  MoviesListCoordinator.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

/**
Manages the Movies list-detail navigation flow.
*/
class MoviesCoordinator: Coordinator<DeepLink> {
    private let moviesListVCFactory: () -> MoviesListViewController
    private let movieDetailsVCFactory: (TMDBMovie) -> MovieDetailsViewController
    
    lazy var moviesListVC: MoviesListViewController = {
        let vc = self.moviesListVCFactory()
        vc.delegate = self
        return vc
    }()
    
    init(router: RouterType,
         moviesListVCFactory: @escaping () -> MoviesListViewController,
         movieDetailsVCFactory: @escaping (TMDBMovie) -> MovieDetailsViewController) {
        self.moviesListVCFactory = moviesListVCFactory
        self.movieDetailsVCFactory = movieDetailsVCFactory
        super.init(router: router)
    }
    
    override func start(with link: DeepLink?) {
        router.setRootModule(moviesListVC, hideBar: false, animated: false)
    }
}
// MARK: - Navigation
extension MoviesCoordinator {
    func showDetails(for movie: TMDBMovie, modally: Bool = false) {
        let movieDetailsVC = movieDetailsVCFactory(movie)
        movieDetailsVC.delegate = self
        if modally {
            router.present(movieDetailsVC, animated: true)
        } else {
            router.push(movieDetailsVC, animated: true, completion: nil)
        }
    }
}

// MARK: - MoviesListViewControllerDelegate
extension MoviesCoordinator: MoviesListViewControllerDelegate {
    func didSelect(movie: TMDBMovie) {
        showDetails(for: movie)
    }
}

extension MoviesCoordinator: MovieDetailsViewControllerDelegate {
    func didSelectSimilarMovie(movie: TMDBMovie) {
        showDetails(for: movie, modally: true)
    }
}
