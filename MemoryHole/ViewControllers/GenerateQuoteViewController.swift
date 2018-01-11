//
//  ViewController.swift
//  MemoryHole
//
//  Created by Ryan Arana on 1/7/18.
//  Copyright © 2018 Ryan Arana. All rights reserved.
//

import UIKit

typealias QuoteReceivedCallback = (_ quote: String, _ vc: GenerateQuoteViewController) -> Void
typealias QuoteRatedCallback = (_ quote: String, _ rating: String, _ vc: GenerateQuoteViewController) -> Void

final class GenerateQuoteViewController: UIViewController {
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet weak var ratingsButtons: UIStackView!

    private lazy var loader: QuoteLoader = { return QuoteLoader(delegate: self) }()

    var quoteRated: QuoteRatedCallback?
    var quoteReceived: QuoteReceivedCallback?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getNewQuote))
        navigationItem.rightBarButtonItem = refresh
    }

    @IBAction func ratingButtonTapped(sender: UIButton) {
        quoteRated?(quoteLabel.text!, sender.titleLabel!.text!, self)
    }

    @objc func getNewQuote() {
        loadViewIfNeeded()
        quoteLabel.text = "Loading..."
        hideRatingsButtons()
        loader.getNewQuote()
    }

    private func hideRatingsButtons() {
        UIView.animate(withDuration: 0.33) {
            self.ratingsButtons.alpha = 0
        }
    }

    private func showRatingsButtons() {
        UIView.animate(withDuration: 0.33) {
            self.ratingsButtons.alpha = 1
        }
    }
}

extension GenerateQuoteViewController: QuoteLoaderDelegate {
    func gotNewQuote(_ quote: String) {
        quoteReceived?(quote, self)
        quoteLabel.text = quote
        showRatingsButtons()
    }

    func getNewQuoteFailed(with error: Error) {
        print("Error: \(error)")
    }
}
