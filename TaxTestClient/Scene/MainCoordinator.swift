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

    private func navigateToLogin() {
        let loginStoryBoard = UIStoryboard(storyboard: .login)
        let loginViewController: LoginViewController = loginStoryBoard.instantiateViewController()
        loginViewController.coordinator = self


        let loginController = LoginController()
        loginViewController.loginController = loginController

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(loginViewController, animated: false)
    }
}
