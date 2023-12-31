//
//  MovieDetailsViewController.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 20.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import RxSwift
import RxCocoa

protocol MovieDetailsViewControllerDelegate: class {
    func didSelectSimilarMovie(movie: TMDBMovie)
}

class MovieDetailsViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var similarMoviesLabel: UILabel!
    
    // MARK: Properties
    weak var delegate: MovieDetailsViewControllerDelegate?
    var viewModel: MovieDetailControllerViewModeling!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        bind(to: viewModel)
    }
    
    // MARK: Methods
    func bind(to viewModel: MovieDetailControllerViewModeling) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: viewModel.imageURL)
        movieTitle.text = viewModel.title
        movieOverview.text = viewModel.overview
        let similarMoviesModule = viewModel.similarMoviesModule
        if presentingViewController == nil {
            add(similarMoviesModule, to: containerView)
        } else {
            similarMoviesLabel.isHiddenInStackView = true
            containerView.isHiddenInStackView = true
        }
        rx.disposeBag.insert(
            // MARK: VM Inputs
            
            // MARK: VM Outputs
            similarMoviesModule.viewModel.movieSelected.subscribeOn(MainScheduler.instance).subscribe(onNext: {[weak self] movie in
                self?.delegate?.didSelectSimilarMovie(movie: movie)
            })
        )
    }
    
    private func setupAppearance() {
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        scrollView.contentInset.bottom = view.bounds.height / 6
        scrollView.contentInset.top = 16
    }
}
