//
//  TaxDeclarationDataSource.swift
//  TaxTestClient
//
//  Created by Willy Breitenbach on 18.10.20.
//

import UIKit

class TaxDeclarationDataSource: NSObject, UITableViewDataSource {
    private var items: [TaxDeclarationSection]

    init(items: [TaxDeclarationSection]) {
        self.items = items
    }

    /// Return item for specific index path
    /// - Parameter indexPath: Selected `IndexPath`
    /// - Returns: `TaxDeclarationResponse`
    func item(for indexPath: IndexPath) -> TaxDeclarationResponse {
        items[indexPath.section].rows[indexPath.row]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaxDeclarationCell", for: indexPath)

        let item = items[indexPath.section].rows[indexPath.row]

        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.lastUsed.toString()

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        items[section].title
    }
}
