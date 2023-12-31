//
//  FavoriteMoviesDataProvider.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 08.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/**
 Helper class for handling movies retreival and pagination
 */
class FavoriteMoviesDataProvider: PaginationSupportable {
    typealias PaginatedItem = TMDBMovie
    typealias Request = Int
    
    private let _loadMore = PublishSubject<Void>()
    private let bgSheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    private var pageToLoad: BehaviorRelay<Request> = BehaviorRelay(value: 1)
    private let moviesRepository: MoviesRepository
    private let disposeBag = DisposeBag()
    
    //Output
    var dataSource: BehaviorRelay<[TMDBMovie]> = BehaviorRelay<[TMDBMovie]>(value: [])
    var error: Driver<String>!
    var isLoadingMore: Driver<Bool>!
    
    //Input
    var loadMore: AnyObserver<Void> { _loadMore.asObserver() }
    
    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
        bind()
    }
    
    func item(at index: Int) -> TMDBMovie? {
        dataSource.value[safe: index]
    }
    
    @discardableResult
    func deleteMovie(at index: Int) -> TMDBMovie? {
        var movies = dataSource.value
        guard index <= movies.count - 1 else { return nil }
        let deletedMovie = movies.remove(at: index)
        dataSource.accept(movies)
        return deletedMovie
    }
    
    func refresh() {
        dataSource.accept([])
        _loadMore.onNext(())
        pageToLoad.accept(0)
    }
    
    private func bind() {
        let loadMoreTrigger = _loadMore
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .withLatestFrom(pageToLoad)
            .distinctUntilChanged()
            .share()
        
        let loadRequest = Observable.deferred {[unowned self] in
            self.loadNextPage(on: loadMoreTrigger)
        }.share()
        
        let movies = loadRequest.compactMap { $0.element }
        let loadingError = loadRequest.compactMap { $0.error }.map { $0.localizedDescription }
        
        movies.map {[weak self] newMovies -> [TMDBMovie] in
            //Get the previously downloaded movies
            var movies: [TMDBMovie] = self?.dataSource.value ?? []
            //Append new movies to the list
            movies.append(contentsOf: newMovies)
            return movies
        }.bind(to: dataSource).disposed(by: disposeBag) //<- Passes data to the dataSource BehaviorRelay
        
        error = loadingError.asDriver(onErrorJustReturn: "")
        isLoadingMore = Observable<Bool>.merge(loadMoreTrigger.map { _ in true }, loadRequest.map { _ in false }).asDriver(onErrorJustReturn: false)
    }
    
    func loadNextPage(on trigger: Observable<Request>) -> Observable<Event<[TMDBMovie]>> {
        let repo = moviesRepository
        let backgroundScheduler = bgSheduler
        return trigger
            .observeOn(backgroundScheduler) //<-- go to BG queue execution
            .flatMapLatest { requestedPage -> Observable<Event<[TMDBMovie]>> in
                repo.getMyFavoriteMovies(page: requestedPage == 0 ? 1 : requestedPage)
                    //Increase next page number if the previous was successfuly downloaded
                    .do(onSuccess: {[weak self] moviesPage in
                        guard !moviesPage.results.isEmpty else { return }
                        self?.pageToLoad.accept(moviesPage.page + 1)
                    })
                    .map { $0.results }
                    .asObservable()
                    .materialize()
                    .observeOn(MainScheduler.instance)//<-- go to MAIN queue execution
        }
    }
}
