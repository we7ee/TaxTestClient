//
//  ViewController.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 15.10.20.
//

import UIKit

class LoginViewController: UIViewController, LoadingIndicatorShowable {

    // LoadingIndicatorShowable
    var loadingIndicator: UIView?

    // Public properties
    weak var coordinator: MainCoordinator?
    var loginController: LoginControlling?

    // Private properties
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        loginController?.didReceiveState = handleState
    }

    // MARK: - Login controller

    private func handleState(_ state: LoginState) {
        switch state {
            case .idle:
                hideLoadingIndicator()
            case .loading:
                showLoadingIndicator()
            case .failed(let loginError):
                hideLoadingIndicator()
                handleLoginError(loginError)
            case .success(let username):
                hideLoadingIndicator()

                let okAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] (action) in
                    guard let self = self else { return }
                    self.coordinator?.navigateToTaxDeclarations()
                }

                showAlert(with: "Success", message: "\(username) logged in successfully.", and: [okAction])
        }
    }

    // MARK: - UI

    private func handleLoginError(_ loginError: LoginError) {
        let errorMessage: String

        switch loginError {
            case .invalidInput(message: let message):
                errorMessage = message
            case .networkError(message: let message):
                errorMessage = message
            case .wrongEmailPassword(message: let message):
                errorMessage = message
        }

        showAlert(with: "Error", message: errorMessage)
    }

    // MARK: - Actions
    @IBAction func loginPressed(_ sender: UIButton) {

        let email = emailTextField.text
        let password = passwordTextField.text

        loginController?.login(with: email, and: password)
    }
}
