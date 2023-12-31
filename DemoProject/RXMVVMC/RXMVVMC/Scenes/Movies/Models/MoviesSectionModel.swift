//
//  MoviesSectionModel.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 27.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import RxDataSources

// MARK: - SectionModel
struct MoviesSectionModel {
    var items: [MovieCellDisplayModel]
}

extension MoviesSectionModel: AnimatableSectionModelType {
    typealias Identity = Int
    typealias Item = MovieCellDisplayModel
    var identity: Int { 0 }
    init(original: MoviesSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
