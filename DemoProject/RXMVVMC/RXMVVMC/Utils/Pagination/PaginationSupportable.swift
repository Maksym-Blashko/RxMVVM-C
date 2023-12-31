//
//  PaginationSupportable.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 08.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PaginationSupportable {
    associatedtype PaginatedItem
    associatedtype Request
    //Output
    ///Emits the requested items
    var dataSource: BehaviorRelay<[PaginatedItem]> { get set }
    var error: Driver<String>! { get }
    var isLoadingMore: Driver<Bool>! { get }
    //Input
    var loadMore: AnyObserver<Void> { get }
    ///Returns the stream (observable) which emits the items of the next page  when  trigger emits a request
    /// - Parameter trigger: Observable which emits the request.
    func loadNextPage(on trigger: Observable<Request>) -> Observable<Event<[PaginatedItem]>>
    ///Reloads the  first page
    func refresh()
}
