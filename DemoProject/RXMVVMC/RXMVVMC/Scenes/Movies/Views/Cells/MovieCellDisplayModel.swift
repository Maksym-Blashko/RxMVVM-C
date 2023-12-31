//
//  MovieCellDisplayModel.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 27.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import Differentiator

struct MovieCellDisplayModel {
    let id: Int
    let title: String
    let language: String
    let posterURL: URL?

    init(from movie: Movie, using config: ImagesConfiguration) {
        id = movie.id
        title = movie.originalTitle
        language = movie.originalLanguage
        guard let posterPath = movie.posterPath, !config.posterSizes.isEmpty else {
            posterURL = nil
            return
        }
        let size = config.posterSizes[safe: 5] ?? "original"
        let urlString = "\(config.secureBaseUrl)\(size)\(posterPath)"
        posterURL = URL(string: urlString)
    }
}

extension MovieCellDisplayModel: IdentifiableType, Equatable {
    typealias Identity = Int
    var identity: Int { id }

    static func == (lhs: MovieCellDisplayModel, rhs: MovieCellDisplayModel) -> Bool {
        return lhs.id == rhs.id
    }
}
