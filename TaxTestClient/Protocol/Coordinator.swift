//
//  Coordinator.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 16.10.20.
//

import UIKit

protocol Coordinator: AnyObject {
    var chilCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
