//
//  StoryboardIdentifiable.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 04.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }

extension UIStoryboard {
    enum Storyboard: String {
        case authorization
        case movies
        case profile
        case demoflow
        
        var filename: String {
            return self.rawValue.capitalized
        }
    }
    
    convenience init(_ storyboard: Storyboard) {
        self.init(name: storyboard.filename, bundle: Bundle.main)
    }
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        return viewController
    }
    
}
