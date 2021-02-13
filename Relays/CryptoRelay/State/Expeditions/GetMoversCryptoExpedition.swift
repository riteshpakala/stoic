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
        
        var needsUpdate: Bool = true
        coreDataInstance.networkResponse(forRoute: state.cryptoWatch.getAggregateSummariesRoute) { result in
            if let data = result?.data {
                if let movers = data.decodeNetwork(type: CryptoServiceModels.GetAggregateSummaries.self) {

                    connection.request(generateEvent(movers, max: state.max, exchange: state.exchange, currency: state.currency))

                    needsUpdate = false
                }
            }
        }
        
        guard needsUpdate else { return }
        
        GraniteLogger.info("fetching new movers\nneeds update:\(needsUpdate) - self: \(String(describing: self))", .network, focus: true)
        
        let decoder = JSONDecoder()
        publisher = pub
            .replaceError(with: .init(data: nil, type: CryptoServiceModels.GetAggregateSummaries.self))
            .map { (response) in
                guard let rawData = response.data else {
                    return CryptoEvents.GlobalCategoryResult.init([], [], [])
                }
                
                guard let decoded = try? decoder.decode(response.type,
                                                        from: rawData) else {
                    return CryptoEvents.GlobalCategoryResult.init([], [], [])
                }
            
                
                coreDataInstance.save(route: state.cryptoWatch.getAggregateSummariesRoute,
                                      data: rawData,
                                      responseType: .movers)
                
                return generateEvent(decoded, max: state.max, exchange: state.exchange, currency: state.currency)
            }.eraseToAnyPublisher()
        
    }
    
    func generateEvent(_ decoded: CryptoServiceModels.GetAggregateSummaries,
                       max: Int,
                       exchange: String,
                       currency: String) ->  CryptoEvents.GlobalCategoryResult {
        let markets = decoded.result.filter {
            $0.key.contains(currency) &&
            !$0.key.contains("\(currency)t") &&
            !$0.key.contains("\(currency)c") &&
            $0.key.contains("\(exchange):")
        }
            
        let summariesSortedByVolume = markets.sorted(by: { $0.value.volume > $1.value.volume })
        let summariesSortedByChange = markets.sorted(by: { $0.value.price.change.percentage > $1.value.price.change.percentage })

        let summariesVolume = summariesSortedByVolume.prefix(max)
        let summariesGainers = summariesSortedByChange.prefix(max)
        let summariesLosers = summariesSortedByChange.suffix(max).sorted(by: { $0.value.price.change.percentage < $1.value.price.change.percentage })
        
        let topVolume: [CryptoCurrency] = summariesVolume.map {
            cryptoCurrency(exchange, currency, $0.key, $0.value)
        }
        
        let gainers: [CryptoCurrency] = summariesGainers.map {
            cryptoCurrency(exchange, currency, $0.key, $0.value)
        }
        
        let losers: [CryptoCurrency] = summariesLosers.map {
            cryptoCurrency(exchange, currency, $0.key, $0.value)
        }
        
        let result = CryptoEvents.GlobalCategoryResult.init(topVolume, gainers, losers)
        
        return result
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
                hasStrategy: false,
                hasPortfolio: false)
    }
}
