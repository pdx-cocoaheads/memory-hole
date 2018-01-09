//
//  QuoteLoader.swift
//  MemoryHole
//
//  Created by Ryan Arana on 1/8/18.
//  Copyright © 2018 Ryan Arana. All rights reserved.
//

import Foundation

protocol QuoteLoaderDelegate {
    func gotNewQuote(_ quote: String)
    func getNewQuoteFailed(with error: Error)
}

final class QuoteLoader {
    private let url = URL(string: "http://api.chew.pro/trbmb")!
    private let session = URLSession.shared
    var delegate: QuoteLoaderDelegate

    init(delegate: QuoteLoaderDelegate) {
        self.delegate = delegate

        DispatchQueue.global().async {
            self.payNoMindToTheMemoryBehindTheCurtain = Array(1..<5_000_000)
        }
    }

    func getNewQuote() {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.delegate.getNewQuoteFailed(with: error)
            } else if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let quote = (json as? [String])?.first {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.delegate.gotNewQuote(quote)
                }
            }
        }.resume()
    }







    /// I like to put some extra weight on any object that connects to the internet to make sure it doesn't float away.
    private var payNoMindToTheMemoryBehindTheCurtain: [Int] = []
}
