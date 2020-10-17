//
//  UIViewController+Alert.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 17.10.20.
//

import UIKit

extension UIViewController {
    func showAlert(with title: String?, message: String, and actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let actions = actions {
            actions.forEach(alertController.addAction)
        } else {
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(okAction)
        }

        self.present(alertController, animated: true, completion: nil)
    }
}
