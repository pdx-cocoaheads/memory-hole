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
        queueButton.title = enquedVCs.count > 0 ? "\(enquedVCs.count)" : "Q"
    }

    @IBAction func pushGenerate(_ sender: UIBarButtonItem) {
        let generateVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "generateVC") as! GenerateQuoteViewController
        generateVC.quoteRated = { quote, rating, _ in  self.quoteRated(quote, rating) }
        generateVC.getNewQuote()
        navigationController?.pushViewController(generateVC, animated: true)
    }

    var enquedVCs = [GenerateQuoteViewController]() {
        didSet { self.updateQueueButton() }
    }
    @IBAction func modalGenerate() {
        let generateVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "generateVC") as! GenerateQuoteViewController
        generateVC.modalPresentationStyle = .overCurrentContext
        generateVC.modalTransitionStyle = .crossDissolve
        generateVC.view.backgroundColor = generateVC.view.backgroundColor?.withAlphaComponent(0.25)
        definesPresentationContext = true

        generateVC.quoteReceived = { [unowned self] _, vc in
            if self.presentedViewController != nil {
                self.queue.isSuspended = true
            } else {
                self.queue.isSuspended = false
            }
            self.queue.addOperation {
                DispatchQueue.main.sync {
                    self.present(vc, animated: true)
                    self.queue.isSuspended = true
                }
            }
        }
        generateVC.quoteRated = { [unowned self] quote, rating, vc in
            DispatchQueue.main.async {
                self.quoteRated(quote, rating)
                vc.dismiss(animated: true) {
                    self.queue.isSuspended = false
                    self.enquedVCs.remove(at: self.enquedVCs.index(of: vc)!)
                }
            }
        }

        generateVC.getNewQuote()
        enquedVCs.append(generateVC)
    }

    private func quoteRated(_ quote: String, _ rating: String) {
        ratings.append((quote, rating))
        tableView.reloadData()
    }
}
