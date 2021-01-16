//
//  GetMoversCryptoExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetMoversCryptoExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.GetMovers
    typealias ExpeditionState = CryptoState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let pub = state.cryptoWatch.getAggregateSummariesPublisher() else {
            return
        }
        
        
        let decoder = JSONDecoder()
        publisher = pub
            .replaceError(with: .init(data: nil, type: CryptoServiceModels.GetAggregateSummaries.self))
            .map { (response) in
                guard let decoded = try? decoder.decode(response.type,
                                                        from: response.data ?? Data()) else {
                    return CryptoEvents.GlobalCategoryResult.init([], [], [])
                }
                
                let markets = decoded.result.filter {
                    $0.key.contains(state.currency) &&
                    !$0.key.contains("\(state.currency)t") &&
                    !$0.key.contains("\(state.currency)c") &&
                     $0.key.contains(state.exchange)
                }
                    
                let summariesSortedByVolume = markets.sorted(by: { $0.value.volume > $1.value.volume })
                let summariesSortedByChange = markets.sorted(by: { $0.value.price.change.percentage > $1.value.price.change.percentage })

                let summariesVolume = summariesSortedByVolume.prefix(state.max)
                let summariesGainers = summariesSortedByChange.prefix(state.max)
                let summariesLosers = summariesSortedByChange.suffix(state.max).sorted(by: { $0.value.price.change.percentage < $1.value.price.change.percentage })
                
                let topVolume: [CryptoCurrency] = summariesVolume.map {
                    cryptoCurrency(state.exchange, state.currency, $0.key, $0.value)
                }
                
                let gainers: [CryptoCurrency] = summariesGainers.map {
                    cryptoCurrency(state.exchange, state.currency, $0.key, $0.value)
                }
                
                let losers: [CryptoCurrency] = summariesLosers.map {
                    cryptoCurrency(state.exchange, state.currency, $0.key, $0.value)
                }
                
                return CryptoEvents.GlobalCategoryResult.init(topVolume, gainers, losers)
            }.eraseToAnyPublisher()
        
    }
    
    func cryptoCurrency(
        _ exchange: String,
        _ currency: String,
        _ key: String,
        _ value: CryptoServiceModels.MarketSummary) -> CryptoCurrency {
        
        let symbol: String = (key.components(
                                separatedBy: exchange+":").last?
                                .components(
                                    separatedBy: currency).first ?? "error").uppercased()
        return CryptoCurrency.init(
                ticker: symbol,
                date: Date(),
                open: 0.0,
                close: value.price.last,
                high: value.price.high,
                low: value.price.low,
                volumeBTC: 0.0,
                volume: value.volume,
                changePercent: value.price.change.percentage,
                changeAbsolute: value.price.change.absolute,
                interval: .day,
                exchangeName: exchange,
                name: symbol,
                isStrategy: false)
    }
}
