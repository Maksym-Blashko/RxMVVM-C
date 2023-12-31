//
//  SimilarMoviesControllerViewModel.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 21.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol SimilarMoviesControllerViewModeling: class, MoviesSectionModelConfigurable {
    var collectionViewDataSource: RxCollectionViewSectionedAnimatedDataSource<MoviesSectionModel> { get }
    // MARK: - Input
    var load: AnyObserver<Void> { get }
    var didSelect: AnyObserver<IndexPath> { get }
    // MARK: - Output
    var isLoading: Driver<Bool>! { get }
    var error: Driver<String>! { get }
    var dataSource: Observable<[MoviesSectionModel]>! { get }
    var movieSelected: Observable<TMDBMovie>! { get }
}

class SimilarMoviesControllerViewModel: SimilarMoviesControllerViewModeling {
    var collectionViewDataSource =  RxCollectionViewSectionedAnimatedDataSource<MoviesSectionModel>(configureCell: { _, _, _, _ in
        fatalError()
    })
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let movieID: MovieID
    private let moviesRepository: MoviesRepository
    private let beConfigRepository: BEConfigurationRepository
    // MARK: - Subjects
    private let _load = PublishSubject<Void>()
    private let _didsSelect = PublishSubject<IndexPath>()
    private let _movies = BehaviorRelay<[TMDBMovie]>(value: [])
    // MARK: - Input
    var load: AnyObserver<Void> { _load.asObserver() }
    var didSelect: AnyObserver<IndexPath> { _didsSelect.asObserver() }
    // MARK: - Output
    var isLoading: Driver<Bool>!
    var error: Driver<String>!
    var dataSource: Observable<[MoviesSectionModel]>!
    var movieSelected: Observable<TMDBMovie>!
    
    // MARK: - Methods
    init(movieID: MovieID, moviesRepository: MoviesRepository, beConfigRepository: BEConfigurationRepository) {
        self.moviesRepository = moviesRepository
        self.beConfigRepository = beConfigRepository
        self.movieID = movieID
        bindOutput()
    }
    
    private func bindOutput() {
        let id = movieID
        let movieRepo = moviesRepository
        dataSource = formMoviesSectionDataSource(from: _movies.asObservable(),
                                                 using: beConfigRepository.currentBEConfiguration.images)
        let loadRequest = _load.flatMapLatest { _ -> Observable<Event<[TMDBMovie]>> in
            movieRepo.getSimilarMovies(movieID: id).map { $0.results }.asObservable().materialize()
        }.share()
        
        let movies = loadRequest.compactMap { $0.element }
        movies.bind(to: _movies).disposed(by: disposeBag)
        
        movieSelected = _didsSelect.map {[weak self] indexPath -> TMDBMovie? in
            self?._movies.value[safe: indexPath.row]
        }.compactMap { $0 }
        
        error = loadRequest.compactMap { $0.error }.map { $0.localizedDescription }.asDriver(onErrorJustReturn: "")
    }
    
}

protocol MoviesSectionModelConfigurable {
    func formMoviesSectionDataSource(from observable: Observable<[TMDBMovie]>, using imageConfig: ImagesConfiguration) -> Observable<[MoviesSectionModel]>
}

extension MoviesSectionModelConfigurable {
    func formMoviesSectionDataSource(from observable: Observable<[TMDBMovie]>, using imageConfig: ImagesConfiguration) -> Observable<[MoviesSectionModel]> {
        observable.skip(1).map { movies -> [MoviesSectionModel] in
            let models = movies.map { MovieCellDisplayModel(from: $0, using: imageConfig)}
            return [MoviesSectionModel(items: models)]
        }
    }
}
