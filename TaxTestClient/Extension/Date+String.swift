//
//  Date+String.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import Foundation

extension Date {
    /// Convert date to readable date. `dateStyle` is `.long`, `timeStyle` is `.short`
    /// - Returns: String from date
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: self)
    }
}
