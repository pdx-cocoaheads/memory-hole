//
//  ViewController.swift
//  MemoryHole
//
//  Created by Ryan Arana on 1/7/18.
//  Copyright © 2018 Ryan Arana. All rights reserved.
//

import UIKit

class GenerateQuoteViewController: UIViewController {
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        getNewQuote()
        rateButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func rateQuote() {
    }

    @IBAction func getNewQuote() {
        URLSession.shared.dataTask(with: URL(string: "http://api.chew.pro/trbmb")!) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let quote = (json as? [String])?.first {
                DispatchQueue.main.async {
                    self.quoteLabel.text = quote
                    self.rateButton.isEnabled = true
                }
            }
        }.resume()
    }
}

