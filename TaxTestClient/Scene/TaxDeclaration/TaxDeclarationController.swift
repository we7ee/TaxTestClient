//
//  TaxDeclarationController.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import Foundation

protocol TaxDeclarationControlling {
    var didReceiveState: ((TaxDeclarationState) -> Void)? { get set }
    func getTaxDeclarations()
}

enum TaxDeclarationError: Equatable, Error {
    case networkError(message: String)
}

enum TaxDeclarationState: Equatable {
    case idle
    case loading
    case success(TaxDeclarationDataSource)
    case failed(TaxDeclarationError)
}

class TaxDeclarationController: TaxDeclarationControlling {
    // Public properties
    /// State oberver closure. Set this closure to observe state changes
    var didReceiveState: ((TaxDeclarationState) -> Void)?

    // Private properties
    private let networkManager: NetworkManaging
    private var state: TaxDeclarationState {
        didSet {
            DispatchQueue.main.async {
                self.didReceiveState?(self.state)
            }
        }
    }

    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
        self.state = .idle
    }

    /// Get all tax declarations for current user
    func getTaxDeclarations() {
        state = .loading

        let taxDeclarationEndpoint = TaxDeclarationEndPoint()

        networkManager.request(for: taxDeclarationEndpoint) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
                case .failure:
                    self.state = .failed(.networkError(message: "An unexpted error occured"))
                case .success(let taxDeclarations):
                    let taxDeclarationSections = self.prepareTaxDeclarationData(from: taxDeclarations)
                    let dataSource = TaxDeclarationDataSource(items: taxDeclarationSections)

                    self.state = .success(dataSource)
            }
        }
    }

    private func prepareTaxDeclarationData(from taxDeclarations: [TaxDeclarationResponse]) -> [TaxDeclarationSection] {
        let years = taxDeclarations.map { $0.year }
        let uniqueYears = Array(Set(years)).sorted()

        var taxDeclarationSections = [TaxDeclarationSection]()

        for year in uniqueYears {
            let title = String(year)
            var rows = [TaxDeclarationResponse]()
            for taxDeclaration in taxDeclarations {
                if year == taxDeclaration.year {
                    rows.append(taxDeclaration)
                }
            }

            if rows.isEmpty == false {
                taxDeclarationSections.append(TaxDeclarationSection(title: title, rows: rows))
            }
        }

        return taxDeclarationSections
    }
}

