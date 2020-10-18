//
//  DateFormatter+API.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import Foundation

extension DateFormatter {
  static let iso8601WihtoutTimeZone: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 1)
    formatter.locale = Locale(identifier: "de_DE")
    return formatter
  }()
}
