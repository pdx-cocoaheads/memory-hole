//
//  ViewController.swift
//  MemoryHole
//
//  Created by Ryan Arana on 1/7/18.
//  Copyright © 2018 Ryan Arana. All rights reserved.
//

import UIKit

protocol GenerateQuoteDelegate {
    func savedRating(_ rating: String, for quote: String)
}

final class GenerateQuoteViewController: UIViewController {
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet weak var ratingsButtons: UIStackView!
    
    var delegate: GenerateQuoteDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        ratingsButtons.alpha = 0
        getNewQuote()
    }

    @IBAction func ratingButtonTapped(sender: UIButton) {
        delegate?.savedRating(sender.titleLabel!.text!, for: quoteLabel.text!)
        UIView.animate(withDuration: 0.33, animations: { self.ratingsButtons.alpha = 0 }, completion: { _ in self.getNewQuote() })
    }

    @IBAction func doneTapped() {
        dismiss(animated: true, completion: nil)
    }

    func getNewQuote() {
        quoteLabel.text = "Loading..."
        URLSession.shared.dataTask(with: URL(string: "http://api.chew.pro/trbmb")!) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let quote = (json as? [String])?.first {
                DispatchQueue.main.async {
                    self.quoteLabel.text = quote
                    UIView.animate(withDuration: 0.33) {
                        self.ratingsButtons.alpha = 1
                    }
                }
            }
        }.resume()
    }
}

