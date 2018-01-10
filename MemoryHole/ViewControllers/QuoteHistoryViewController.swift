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

    private let queue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    private var generateVCCount = 0 {
        didSet { self.updateQueueButton() }
    }

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

        updateQueueButton()
    }

    func updateQueueButton() {
        let queueButton = navigationItem.rightBarButtonItems!.filter({ $0.tag == 1 }).first!
        queueButton.title = generateVCCount > 0 ? "\(generateVCCount)" : "Q"
    }

    @IBAction func pushGenerate(_ sender: UIBarButtonItem) {
        let generateVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "generateVC") as! GenerateQuoteViewController
        generateVC.quoteRated = quoteRated
        generateVC.getNewQuote()
        navigationController?.pushViewController(generateVC, animated: true)
    }

    @IBAction func modalGenerate() {
        let generateVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "generateVC") as! GenerateQuoteViewController
        generateVC.modalPresentationStyle = .overCurrentContext
        generateVC.modalTransitionStyle = .crossDissolve
        generateVC.view.backgroundColor = generateVC.view.backgroundColor?.withAlphaComponent(0.25)
        definesPresentationContext = true

        generateVC.quoteReceived = { _ in
            if self.presentedViewController != nil {
                self.queue.isSuspended = true
            } else {
                self.queue.isSuspended = false
            }
            self.queue.addOperation {
                DispatchQueue.main.sync {
                    self.present(generateVC, animated: true)
                    self.queue.isSuspended = true
                }
            }
        }
        generateVC.quoteRated = { quote, rating in
            DispatchQueue.main.async {
                self.quoteRated(quote, rating)
                generateVC.dismiss(animated: true) {
                    self.queue.isSuspended = false
                    self.generateVCCount -= 1
                }
            }
        }

        generateVC.getNewQuote()
        generateVCCount += 1
    }

    private func quoteRated(_ quote: String, _ rating: String) {
        ratings.append((quote, rating))
        tableView.reloadData()
    }
}
