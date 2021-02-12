//
//  GetCryptoHistoryExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/12/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetCryptoHistoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.GetCryptoHistory
    typealias ExpeditionState = CryptoState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
            
        let pastDate: Date = Date.today.advanceDate(value: -1*abs(event.daysAgo))
        
        guard let pub = state.cryptoWatch
                .getMarketOHLCPublisher(
                    exchange: state.exchange,
                    pair: event.security.ticker+state.currency,
                    before: nil,
                    after: pastDate.timeIntervalSince1970.asInt,
                    periods: [event.interval.seconds]) else { // 86400 == 1day
            return
        }
        
        
        let decoder = JSONDecoder()
        publisher = pub
            .replaceError(with: .init(data: nil, type: CryptoServiceModels.GetMarketOHLC.self))
            .map { (response) in
                
                guard let decoded = try? decoder.decode(response.type,
                                                        from: response.data ?? Data()) else {
                    return CryptoEvents.History.init(data: [], interval: event.interval)
                }
                
                var coins: [CryptoCurrency] = []
                for key in decoded.result.keys {
                    if let history = decoded.result[key] {
                        for index in 0..<history.count {
                            let data = history[index]
                            
                            if data.count >= 7 {
                                let time = data[0]
                                let open = data[1]
                                let high = data[2]
                                let low = data[3]
                                let close = data[4]
                                let volume = data[5]
                                let quoteVolume = data[6]
                                
                                let lastClose = index - 1 > 0 ? history[index - 1][4] : close
                                
                                let changePercent = (close - lastClose) / close
                                let changeAbsolue = close - lastClose
                                
                                coins.append(.init(ticker: event.security.ticker,
                                                   date: time.date(),
                                                   open: open,
                                                   close: close,
                                                   high: high,
                                                   low: low,
                                                   volumeBTC: volume,
                                                   volume: quoteVolume,
                                                   changePercent: changePercent,
                                                   changeAbsolute: changeAbsolue,
                                                   interval: event.interval,
                                                   exchangeName: state.exchange,
                                                   name: event.security.name,
                                                   hasStrategy: event.security.hasStrategy,
                                                   hasPortfolio: event.security.hasPortfolio))
                            }
                        }
                    }
                }
                
                return CryptoEvents.History.init(data: coins, interval: event.interval)
            }.eraseToAnyPublisher()
    }
}
