//
//  TaxDeclarationDetailController.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import Foundation

protocol TaxDeclarationDetailControlling {
    var didReceiveState: ((TaxDeclarationDetailState) -> Void)? { set get }
    func openTaxDeclaration(with id: Int)
}

enum TaxDeclarationDetailError: Equatable, Error {
    case networkError(message: String)
}

enum TaxDeclarationDetailState: Equatable {
    case idle
    case loading
    case success(OpenTaxDeclarationResponse)
    case failed(TaxDeclarationDetailError)
}

class TaxDeclarationDetailController: TaxDeclarationDetailControlling {
    /// State oberver closure. Set this closure to observe state changes
    var didReceiveState: ((TaxDeclarationDetailState) -> Void)?

    // Private properties
    private let networkManager: NetworkManaging
    private var state: TaxDeclarationDetailState {
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

    func openTaxDeclaration(with id: Int) {
        let openTaxDeclarationEndPoint = OpenTaxDeclarationEndPoint(taxDeclaration: id)

        networkManager.request(for: openTaxDeclarationEndPoint) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
                case .failure:
                    self.state = .failed(.networkError(message: "An unexpted error occured"))
                case .success(let openTaxDeclaration):
                    self.state = .success(openTaxDeclaration)
            }
        }
    }
}
