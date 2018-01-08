//
//  QuoteHistoryViewController.swift
//  MemoryHole
//
//  Created by Ryan Arana on 1/7/18.
//  Copyright © 2018 Ryan Arana. All rights reserved.
//

import UIKit

final class QuoteHistoryViewController: UITableViewController {
    var ratings = [(quote: String, rating: String)]()
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white

        let rating = ratings[indexPath.row]
        cell.textLabel?.text = rating.quote
        cell.detailTextLabel?.text = rating.rating

        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let quoteVC = segue.destination as? GenerateQuoteViewController else { return }
        quoteVC.delegate = self
    }
}

extension QuoteHistoryViewController: GenerateQuoteDelegate {
    func savedRating(_ rating: String, for quote: String) {
        ratings.append((quote, rating))
        tableView.reloadData()
    }
}
