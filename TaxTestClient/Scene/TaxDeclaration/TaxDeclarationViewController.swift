//
//  TaxDeclarationViewController.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import UIKit

class TaxDeclarationViewController: UIViewController, LoadingIndicatorShowable {

    // LoadingIndicatorShowable
    var loadingIndicator: UIView?

    // Public properties
    weak var coordinator: MainCoordinator?
    var taxDeclarationController: TaxDeclarationControlling?

    // Private properties
    @IBOutlet private var tableView: UITableView!
    private var taxDeclarationDataSource: TaxDeclarationDataSource?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self

        taxDeclarationController?.didReceiveState = handleState

        taxDeclarationController?.getTaxDeclarations()
    }

    // MARK: - TaxDeclaration controller

    private func handleState(_ state: TaxDeclarationState) {
        switch state {
            case .idle:
                hideLoadingIndicator()
            case .loading:
                showLoadingIndicator()
            case .failed(let taxDeclarationError):
                hideLoadingIndicator()
                handleTaxDeclarationError(taxDeclarationError)

            case .success(let taxDeclarationDataSource):
                self.taxDeclarationDataSource = taxDeclarationDataSource
                self.tableView.dataSource = taxDeclarationDataSource
                self.tableView.reloadData()

                hideLoadingIndicator()
        }
    }

    // MARK: - UI

    private func handleTaxDeclarationError(_ taxDeclarationError: TaxDeclarationError) {
        switch taxDeclarationError {
            case .networkError(message: let message):
                showAlert(with: "Error", message: message)
        }
    }
}

// MARK: - UITableViewDelegate

extension TaxDeclarationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = taxDeclarationDataSource?.item(for: indexPath) else {
            return
        }

        coordinator?.navigateToTaxDeclaration(with: item.id)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
