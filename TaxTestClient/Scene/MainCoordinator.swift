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

    /// Navigate to TaxDeclarationViewController wich shows all tax declarations
    func navigateToTaxDeclarations() {

        // Remove login view controller from navigarion controller
        navigationController.viewControllers.removeAll()

        let taxDeclarationStoryboard = UIStoryboard(storyboard: .taxDeclaration)
        let taxDeclarationViewController: TaxDeclarationViewController = taxDeclarationStoryboard.instantiateViewController()

        taxDeclarationViewController.coordinator = self

        taxDeclarationViewController.title = "Tax declarations"

        let taxDeclarationController = TaxDeclarationController()
        taxDeclarationViewController.taxDeclarationController = taxDeclarationController
        
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(taxDeclarationViewController, animated: false)
    }

    /// Navigate to TaxDeclarationDetailViewController for a selected TaxDeclaration id
    /// - Parameter id: ID of selected TaxDeclaration
    func navigateToTaxDeclaration(with id: Int) {
        let taxDeclarationDetailStoryboard = UIStoryboard(storyboard: .taxDeclarationDetail)
        let taxDeclarationDetailViewController: TaxDeclarationDetailViewController = taxDeclarationDetailStoryboard.instantiateViewController()

        taxDeclarationDetailViewController.coordinator = self
        taxDeclarationDetailViewController.taxDeclarationDetailController = TaxDeclarationDetailController()
        taxDeclarationDetailViewController.taxDeclarationID = id

        navigationController.pushViewController(taxDeclarationDetailViewController, animated: true)
    }

    private func navigateToLogin() {
        let loginStoryboard = UIStoryboard(storyboard: .login)
        let loginViewController: LoginViewController = loginStoryboard.instantiateViewController()
        loginViewController.coordinator = self


        let loginController = LoginController()
        loginViewController.loginController = loginController

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(loginViewController, animated: false)
    }
}
