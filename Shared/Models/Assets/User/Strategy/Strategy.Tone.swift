//
//  Strategy.Tone.Generate.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/10/21.
//

import Foundation

extension Strategy {
    //Update tonal prediction for investments
    public func generate() {
        for quote in quotes {
            if let index = investments.items.firstIndex(where: { $0.assetID == quote.latestSecurity.assetID }) {
                let mutableQuote: Quote = quote
                var model = mutableQuote.models.first
                var prediction = model?.predictAll()
                prediction?.current = mutableQuote.latestValue
                if let prediction = prediction {
                    self.investments.items[index].prediction = prediction
                }
            }
        }
    }
}
