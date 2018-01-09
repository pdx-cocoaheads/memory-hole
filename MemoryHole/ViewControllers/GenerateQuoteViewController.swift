//
//  ViewController.swift
//  MemoryHole
//
//  Created by Ryan Arana on 1/7/18.
//  Copyright © 2018 Ryan Arana. All rights reserved.
//

import UIKit

typealias QuoteRatedCallback = (_ quote: String, _ rating: String) -> Void
final class GenerateQuoteViewController: UIViewController {
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet weak var ratingsButtons: UIStackView!

    private var loader: QuoteLoader!

    var quoteRated: QuoteRatedCallback?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        ratingsButtons.alpha = 0
        loader = QuoteLoader(delegate: self)
        getNewQuote()
    }

    @IBAction func ratingButtonTapped(sender: UIButton) {
        quoteRated?(quoteLabel.text!, sender.titleLabel!.text!)
        UIView.animate(withDuration: 0.33, animations: { self.ratingsButtons.alpha = 0 }, completion: { _ in
            self.getNewQuote()
        })
    }

    func getNewQuote() {
        quoteLabel.text = "Loading..."
        loader.getNewQuote()
    }
}

extension GenerateQuoteViewController: QuoteLoaderDelegate {
    func gotNewQuote(_ quote: String) {
        quoteLabel.text = quote
        UIView.animate(withDuration: 0.33) {
            self.ratingsButtons.alpha = 1
        }
    }

    func getNewQuoteFailed(with error: Error) {
        print("Error: \(error)")
    }
}
