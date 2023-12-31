//
//  MovieListViewController.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 05.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SVProgressHUD

protocol MoviesListViewControllerDelegate: class {
    func didSelect(movie: TMDBMovie)
}

class MoviesListViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    static let startLoadingOffset: CGFloat = 60.0
    weak var delegate: MoviesListViewControllerDelegate?
    var viewModel: MoviesListViewModeling!
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        return searchController
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addSearchController()
        bind(to: viewModel)
        viewModel.load.onNext(())
    }
    
    private func addSearchController() {
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: Methods
    func bind(to viewModel: MoviesListViewModeling) {
        let tableView: UITableView = self.tableView
        //Cell setup
        viewModel.tableViewDataSource.configureCell = {(_, tableView, indexPath, item) in
            guard let cell = MovieTableViewCell.reuse(forTableView: tableView, indexPath: indexPath) as? MovieTableViewCell else { fatalError("Unexpected index path")}
            cell.setup(with: item)
            return cell
        }
        //Allow editing (delete)
        viewModel.tableViewDataSource.canEditRowAtIndexPath  = { dataSource, indexPath  in true }
        // MARK: - Bindings
        rx.disposeBag.insert(
            // MARK: VM Inputs
            tableView.rx.contentOffset.asDriver()
                .withLatestFrom(viewModel.isLoading)
                .flatMap { isLoading in
                    return tableView.isNearBottomEdge(edgeOffset: MoviesListViewController.startLoadingOffset) && !isLoading
                        ? Signal.just(())
                        : Signal.empty()
            }.asObservable()
                .throttle(.seconds(1), scheduler: MainScheduler.instance)
                .bind(to: viewModel.load),
            
            tableView.rx.itemSelected.do(afterNext: { indexPath in
                tableView.deselectRow(at: indexPath, animated: true)
            }).bind(to: viewModel.didSelect),
            
            tableView.rx.itemDeleted.bind(to: viewModel.didDeleteMovie),
            
            searchController.searchBar.rx.text.orEmpty.bind(to: viewModel.searchString),
            // MARK: VM Outputs
            viewModel.isLoading.drive(onNext: {[weak self] isLoading in
                self?.setIsNewPageLoading(isLoading)
            }),
            viewModel.selectedMovie.subscribe(onNext: {[weak self] movie in
                self?.delegate?.didSelect(movie: movie)
            }),
            viewModel.errors.drive(onNext: { error in
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: error)
            }),
            viewModel.dataSource.bind(to: tableView.rx.items(dataSource: viewModel.tableViewDataSource))
        )
    }
    
    private func setIsNewPageLoading(_ isLoading: Bool) {
        if isLoading {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.color = UIColor.black
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(100))
            tableView.tableFooterView = spinner
        } else {
            tableView.tableFooterView = nil
        }
        tableView.tableFooterView?.isHidden = !isLoading
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: MovieTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        tableView.contentInset.bottom = 100
        tableView.estimatedRowHeight = 300
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        viewModel.refresh()
    }
}
