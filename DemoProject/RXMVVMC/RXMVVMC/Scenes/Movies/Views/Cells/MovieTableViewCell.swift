//
//  MovieTableViewCell.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 07.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieSubtitleLabel: UILabel!
    @IBOutlet weak var img: UIImageView!

    override func prepareForReuse() {
        img.kf.cancelDownloadTask()
        movieTitleLabel.text = ""
        movieSubtitleLabel.text = ""
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius = 8
        img.layer.masksToBounds = true
    }

    func setup(with model: MovieCellDisplayModel) {
        movieTitleLabel.text = model.title
        movieSubtitleLabel.text = model.language
        img.kf.indicatorType = .activity
        img.kf.setImage(with: model.posterURL)
    }

}
