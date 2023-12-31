//
//  MoviesListControllerViewModel.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol MoviesListViewModeling: class, MoviesSectionModelConfigurable {
    var tableViewDataSource: RxTableViewSectionedAnimatedDataSource<MoviesSectionModel> { get }
    // MARK: - Input
    var load: AnyObserver<Void> { get }
    var didSelect: AnyObserver<IndexPath> { get }
    var didDeleteMovie: AnyObserver<IndexPath> { get }
    var searchString: AnyObserver<String> { get }
    func refresh()
    // MARK: - Output
    var isLoading: Driver<Bool>! { get }
    var errors: Driver<String>! { get }
    var dataSource: Observable<[MoviesSectionModel]>! { get }
    var selectedMovie: Observable<TMDBMovie>! { get }
}

class MovieListControllerViewModel: MoviesListViewModeling {
    // MARK: - Properties
    private let dataProvider: FavoriteMoviesDataProvider
    private let beConfigRepository: BEConfigurationRepository
    private let moviesRepository: MoviesRepository
    private let disposeBag = DisposeBag()
    var tableViewDataSource = RxTableViewSectionedAnimatedDataSource<MoviesSectionModel>(configureCell: { _, _, _, _ in
        fatalError()
    })
    // MARK: - Subjects
    private let _load = PublishSubject<Void>()
    private let _didSelect = PublishSubject<IndexPath>()
    private let _didDelete = PublishSubject<IndexPath>()
    private let _searchString = BehaviorSubject<String>(value: "")
    // MARK: - Input
    var load: AnyObserver<Void> { _load.asObserver() }
    var didSelect: AnyObserver<IndexPath> { _didSelect.asObserver() }
    var didDeleteMovie: AnyObserver<IndexPath> { _didDelete.asObserver() }
    var searchString: AnyObserver<String> { _searchString.asObserver() }
    // MARK: - Output
    var isLoading: Driver<Bool>!
    var errors: Driver<String>!
    var dataSource: Observable<[MoviesSectionModel]>!
    var selectedMovie: Observable<TMDBMovie>!

    // MARK: - Methods
    init(dataProvider: FavoriteMoviesDataProvider,
         moviesRepository: MoviesRepository,
         beConfigurationRepository: BEConfigurationRepository) {
        self.beConfigRepository = beConfigurationRepository
        self.dataProvider = dataProvider
        self.moviesRepository = moviesRepository
        bindOutput()
    }

    private func bindOutput() {
        let movieRepo = moviesRepository
        let provider = dataProvider
        
        dataSource = formMoviesSectionDataSource(from: filteredMovies(), using: beConfigRepository.currentBEConfiguration.images)
        
        _load.bind(to: provider.loadMore).disposed(by: disposeBag)

       let removeFromFavoriteRequest = _didDelete.map { indexPath -> (movie: TMDBMovie, indexPath: IndexPath) in
            guard let movie = provider.item(at: indexPath.row) else { fatalError("Unexpected index") }
            return (movie: movie, indexPath: indexPath)
        }.flatMap { (movie, indexPath) -> Observable<Event<Int>> in
            movieRepo.markAsFavorite(mediaID: movie.id, favorite: false).map { _ in return indexPath.row }.asObservable().materialize()
        }.share()

        let removedRow = removeFromFavoriteRequest.compactMap { $0.element }
        removedRow.subscribe(onNext: { row in
            provider.deleteMovie(at: row)
        }).disposed(by: disposeBag)
        let removingError = removeFromFavoriteRequest.compactMap { $0.error?.localizedDescription }

        isLoading = dataProvider.isLoadingMore
        selectedMovie = _didSelect.map { indexPath -> TMDBMovie? in
            let movie = provider.item(at: indexPath.row)
            return movie
        }.compactMap { $0 }
        
        errors = Observable<String>.merge(dataProvider.error.asObservable(),
                                              removingError).asDriver(onErrorJustReturn: "")
    }

    func refresh() {
        dataProvider.refresh()
    }
    
    private func filteredMovies() -> Observable<[TMDBMovie]> {
        let debouncedSearch = _searchString
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        
        return Observable<[TMDBMovie]>.combineLatest(dataProvider.dataSource.asObservable(), debouncedSearch) { (data, searchString) -> [TMDBMovie] in
            guard !searchString.isEmpty else { return data }
            return data.filter { $0.originalTitle.lowercased().contains(searchString.lowercased()) }
        }
    }
}
