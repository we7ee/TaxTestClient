//
//  TaxDeclarationDetailViewController.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import UIKit

class TaxDeclarationDetailViewController: UIViewController, LoadingIndicatorShowable {

    // LoadingIndicatorShowable
    var loadingIndicator: UIView?

    // Public properties
    weak var coordinator: MainCoordinator?
    var taxDeclarationDetailController: TaxDeclarationDetailControlling?
    var taxDeclarationID: Int!

    // Private properties
    @IBOutlet private var textStackView: UIStackView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var lastUsedLabel: UILabel!


    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        taxDeclarationDetailController?.didReceiveState = handleState
        taxDeclarationDetailController?.openTaxDeclaration(with: taxDeclarationID)
    }

    // MARK: - TaxDeclarationDetail controller

    private func handleState(_ state: TaxDeclarationDetailState) {
        switch state {
            case .idle:
                hideLoadingIndicator()
            case .loading:
                showLoadingIndicator()
            case .failed(let error):
                hideLoadingIndicator()
                handleError(error)
            case .success(let declarationResponse):
                hideLoadingIndicator()
                updateUI(with: declarationResponse)
        }
    }

    private func handleError(_ taxDeclarationDetailError: TaxDeclarationDetailError) {
        switch taxDeclarationDetailError {
            case .networkError(message: let message):
                showAlert(with: "Error", message: message)
        }
    }

    // MARK: - UI

    private func setupUI() {
        textStackView.isHidden = true
    }

    private func updateUI(with taxDeclaration: OpenTaxDeclarationResponse) {
        titleLabel.text = taxDeclaration.name
        lastUsedLabel.text = taxDeclaration.lastUsed.toString()

        textStackView.isHidden = false
    }
}
