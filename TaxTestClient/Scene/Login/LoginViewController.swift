//
//  ViewController.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 15.10.20.
//

import UIKit

class LoginViewController: UIViewController {

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
                print("Do nothing for now")
            case .loading:
                #warning("TODO: Show loading indicator")
            case .failed(let loginError):
                handleLoginError(loginError)
            case .success(let user):
                showAlert(with: "Success", message: "\(user.userName ?? "") logged in successfully.")
        }
    }

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

