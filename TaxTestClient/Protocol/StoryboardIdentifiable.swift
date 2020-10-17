//
//  StoryboardIdentifiable.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 16.10.20.
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
