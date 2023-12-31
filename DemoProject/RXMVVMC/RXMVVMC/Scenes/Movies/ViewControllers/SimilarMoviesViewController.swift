//
//  SimilarMoviesViewController.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 21.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SimilarMoviesViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    var viewModel: SimilarMoviesControllerViewModeling!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: MovieCollectionViewCell.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
        collectionView.contentInset.left = 16
        collectionView.contentInset.right = 16
        bind(to: viewModel)
        viewModel.load.onNext(())
    }
    
    // MARK: Methods
    func bind(to viewModel: SimilarMoviesControllerViewModeling) {
        let collection = collectionView
        //Cell setup
        viewModel.collectionViewDataSource.configureCell = {(_, collectionView, indexPath, item) in
            guard let cell = MovieCollectionViewCell.reuse(forCollectionView: collectionView,
                                                           indexPath: indexPath) as? MovieCollectionViewCell
            else { fatalError("Unexpected index or failed to get cell") }
            
            cell.setup(with: item.posterURL, title: item.title)
            return cell
        }
        // MARK: - Bindings
        rx.disposeBag.insert(
            // MARK: VM Inputs
            collectionView.rx.itemSelected.do(afterNext: { indexPath in
                collection?.deselectItem(at: indexPath, animated: true)
            }).bind(to: viewModel.didSelect),
            // MARK: VM Outputs
            viewModel.dataSource.bind(to: collectionView.rx.items(dataSource: viewModel.collectionViewDataSource)),
            
            collectionView.rx.setDelegate(self)
        )
       
    }
}

extension SimilarMoviesViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let noOfCellsInRow = 3
//        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { fatalError("No layout") }
//        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumLineSpacing * CGFloat(noOfCellsInRow - 1)
//        let width = (collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow)
//        return CGSize(width: width, height: collectionView.bounds.height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//    }
////
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 0 }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 16 }
}
