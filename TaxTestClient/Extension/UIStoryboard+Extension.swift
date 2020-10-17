//
//  Storyboard+Extension.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 16.10.20.
//

import UIKit

extension UIStoryboard {

    // MARK: - Convenience Initializers
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }

    // MARK: - Class Functions
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }

    // MARK: - View Controller Instantiation from Generics
    func instantiateViewController<T: StoryboardIdentifiable>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier)")
        }

        return viewController
    }
}
