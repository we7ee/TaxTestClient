//
//  LoginController.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 17.10.20.
//

import Foundation

protocol LoginControlling {
    var didReceiveState: ((LoginState) -> Void)? { set get }
    func login(with username: String?, and password: String?)
}

enum LoginError: Equatable, Error {
    case invalidInput(message: String)
    case wrongEmailPassword(message: String)
    case networkError(message: String)
}

enum LoginState: Equatable {
    case idle
    case loading
    case success(username: String)
    case failed(LoginError)
}

class LoginController: LoginControlling {

    // Public properties
    /// State oberver closure. Set this closure to observe state changes
    var didReceiveState: ((LoginState) -> Void)?

    // Private properties
    private let networkManager: NetworkManaging
    private var state: LoginState {
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

    // Public API

    /// Perform login with email and password
    /// - Parameters:
    ///   - email: User Email adress
    ///   - password: User Password
    func login(with email: String?, and password: String?) {

        if isInputValid(email: email, password: password) == false {
            state = .failed(.invalidInput(message: "Your input is not valid. Please enter valid email and password"))
            return
        }

        guard let email = email, let password = password else {
            return
        }

        let loginEndpoint = LoginUserEndPoint(email: email, password: password)

        state = .loading

        networkManager.request(for: loginEndpoint) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
                case .success(let userResponse):
                    if userResponse.error == "ok" {
                        self.state = .success(username: userResponse.userName ?? "-")
                    } else {
                        self.state = .failed(.wrongEmailPassword(message: "Wrong email or password. Please try again"))
                    }
                case .failure:
                    self.state = .failed(.networkError(message: "A network error occured"))
            }
        }
    }

    // Private API

    private func isInputValid(email: String?, password: String?) -> Bool {
        guard let email = email, let password = password else {
            return false
        }

        if email.isEmpty || password.isEmpty {
            return false
        } else {
            return true
        }
    }
}
