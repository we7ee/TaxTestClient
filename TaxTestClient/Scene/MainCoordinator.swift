//
//  MainCoordinator.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 16.10.20.
//

import UIKit

class MainCoordinator: Coordinator {
    var chilCoordinators = [Coordinator]()

    var navigationController = UINavigationController()

    private var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        navigateToLogin()
    }

    func navigateToLogin() {
        let loginStoryBoard = UIStoryboard(storyboard: .login)
        let loginViewController: LoginViewController = loginStoryBoard.instantiateViewController()
        loginViewController.modalPresentationStyle = .fullScreen

        navigationController.present(loginViewController, animated: false, completion: nil)
    }
}
