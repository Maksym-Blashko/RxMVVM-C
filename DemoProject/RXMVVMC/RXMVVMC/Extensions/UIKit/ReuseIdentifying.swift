//
//  ReuseIdentifying.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 07.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import UIKit

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
extension UITableViewCell: ReuseIdentifying {
    public static func reuse(forTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
    }
}
extension UICollectionViewCell: ReuseIdentifying {
    public static func reuse(forCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseIdentifier, for: indexPath)
    }
}
