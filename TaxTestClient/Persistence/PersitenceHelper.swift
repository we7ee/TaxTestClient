//
//  PersitenceHelper.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import Foundation

struct PersitenceHelper {
    enum UserDefaultsKey: String {
        case restState
    }

    /// Rest state from buhl API
    static var restState: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.restState.rawValue)
        }
        get {
            let value = UserDefaults.standard.value(forKey: UserDefaultsKey.restState.rawValue)
            return value as? String
        }
    }
}
