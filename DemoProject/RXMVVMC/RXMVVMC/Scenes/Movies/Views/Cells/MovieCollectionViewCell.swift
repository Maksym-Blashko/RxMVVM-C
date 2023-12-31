//
//  MovieCollectionViewCell.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 21.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var movTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
    }
    
    func setup(with imageURL: URL?, title: String) {
        imageView.kf.setImage(with: imageURL)
        movTitleLabel.text = title
    }
}
