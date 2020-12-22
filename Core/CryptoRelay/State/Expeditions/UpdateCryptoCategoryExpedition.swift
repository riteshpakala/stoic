//
//  UpdateCryptoCategoryExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/21/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct UpdateCryptoCategoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.UpdateCategory
    typealias ExpeditionState = CryptoState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let decoder = JSONDecoder()
        publisher = Cryptowatcher()
            .getAggregateSummariesPublisher()!
            .replaceError(with: .init(data: nil, type: CryptoModels.GetAggregateSummaries.self))
            .map { (response) in
                guard let decoded = try? decoder.decode(response.type, from: response.data ?? Data()) else {
                    return CryptoEvents.CategoryResult.init([])
                }
                
                let markets = decoded.result.filter {
                    $0.key.contains(state.currency) &&
                        !$0.key.contains("\(state.currency)t") &&
                        !$0.key.contains("\(state.currency)c") &&
                            $0.key.contains(state.exchange)
                }
                    
                let summariesSorted = markets.sorted(by: { $0.value.volume > $1.value.volume })

                let summaries = summariesSorted.prefix(state.max)
                
                let cryptoCurrencies: [CryptoCurrency] = summaries.map {
                    CryptoCurrency.init(
                        ticker: ($0.key.components(
                            separatedBy: state.exchange+":").last?
                            .components(
                                separatedBy: state.currency).first ?? "error").uppercased(),
                        date: Date(),
                        last: $0.value.price.last,
                        high: $0.value.price.high,
                        low: $0.value.price.low,
                        volume: $0.value.volume,
                        changePercent: $0.value.price.change.percentage,
                        changeAbsolute: $0.value.price.change.absolute)
                    
                }
                
                return CryptoEvents.CategoryResult.init(cryptoCurrencies)
            }.eraseToAnyPublisher()
        
//        Cryptowatcher().getAggregateSummaries().then { response in
//
//            let markets = response.result.filter {
//                $0.key.contains(state.currency) &&
//                    !$0.key.contains("\(state.currency)t") &&
//                    !$0.key.contains("\(state.currency)c") &&
//                        $0.key.contains(state.exchange)
//            }
//
//            let summariesSorted = markets.sorted(by: { $0.value.volume > $1.value.volume })
//
//
////            let remainingAllowance = response.allowance.remaining
//
//            let summaries = summariesSorted.prefix(state.max)
//
//
//
//            let cryptoCurrencies: [CryptoCurrency] = summaries.map {
//                CryptoCurrency.init(
//                    ticker: ($0.key.components(
//                        separatedBy: state.exchange+":").last?
//                        .components(
//                            separatedBy: state.currency).first ?? "error").capitalized,
//                    date: Date(),
//                    last: $0.value.price.last,
//                    high: $0.value.price.high,
//                    low: $0.value.price.low,
//                    volume: $0.value.volume)
//
//            }
//
//         // Use the values to do something fun
//        }.onError { error in
//         // Handle the error
//            print("{TEST 2} \(error.localizedDescription)")
//        }
        
    }
}
