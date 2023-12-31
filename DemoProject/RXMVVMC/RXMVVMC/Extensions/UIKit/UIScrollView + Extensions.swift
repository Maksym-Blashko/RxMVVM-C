//
//  UIScrillView + Extensions.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 08.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
