//
//  Storyboard.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 16.10.20.
//

import Foundation

/// An enum with all available Storyboard tha can be used to instatiate the containing UIViewController
enum Storyboard: String {
    case login = "Login"
    case taxDeclaration = "TaxDeclaration"
    case taxDeclarationDetail = "TaxDeclarationDetail"
}
