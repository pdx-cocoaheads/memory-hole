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
}
