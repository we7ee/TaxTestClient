//
//  LoadingIndicatorShowable.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import UIKit

protocol LoadingIndicatorShowable: AnyObject {
    var loadingIndicator: UIView? { set get }
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

extension LoadingIndicatorShowable where Self: UIViewController {
    func showLoadingIndicator() {
        if loadingIndicator == nil {
            let loadingView = UIView(frame: self.view.frame)

            let activityIndicator = UIActivityIndicatorView(style: .large)
            let textLabel = UILabel()
            textLabel.text = "Loading..."

            let stackView = UIStackView(arrangedSubviews: [activityIndicator, textLabel])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.translatesAutoresizingMaskIntoConstraints = false

            loadingView.addSubview(stackView)

            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
            ])

            loadingIndicator = loadingView

            DispatchQueue.main.async {
                activityIndicator.startAnimating()
                self.view.addSubview(loadingView)
            }
        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator?.removeFromSuperview()
            self.loadingIndicator = nil
        }
    }
}
