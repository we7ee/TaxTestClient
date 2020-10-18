//
//  TaxDeclarationSection.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import Foundation

struct TaxDeclarationSection {
    let title: String
    let rows: [TaxDeclarationResponse]
}

extension TaxDeclarationSection: Equatable {}
