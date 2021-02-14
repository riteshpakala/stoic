//
//  GetMoversStockExpeditionExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetMoversStockExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.GetMovers
    typealias ExpeditionState = StockState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        var needsUpdate: Bool = true
        coreDataInstance.networkResponse(forRoute: state.service.movers) { result in
            if let data = result?.data {
                
                if let unarchivedData = data.decodeNetwork(type: StockServiceModels.MoversArchiveable.self),
                   let movers = unarchivedData.movers {
                    connection.request(StockEvents.MoverStockQuotes(movers: movers, quotes: unarchivedData.quotes))
                    
                    GraniteLogger.info("got the cached movers", .expedition, focus: true)
                }
                
                needsUpdate = false
            }
        }
        
        if needsUpdate {
            publisher = state
                .service
                .getMovers()
                .replaceError(with: nil)
                .map { StockEvents.MoversData(data: $0) }
                .eraseToAnyPublisher()

            GraniteLogger.info("fetching new movers\nneeds update:\(needsUpdate) - self: \(String(describing: self))", .network, focus: true)
        }
    }
}

struct MoversDataExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.MoversData
    typealias ExpeditionState = StockState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        
        guard let data = event.data as? StockServiceModels.Movers else { return }
        
        let symbols: [String] = data.finance.result.flatMap { item in item.quotes.map { $0.symbol } }
        
        publisher = state
            .service
            .getQuotes(symbols: symbols.uniques.joined(separator: ","))
            .replaceError(with: [])
            .map {
                
                let archive: StockServiceModels.MoversArchiveable = .init(data, $0)
                if let data = archive.archived {
                    coreDataInstance.save(route: state.service.movers,
                                          data: data,
                                          responseType: .movers)
                }
                
                return StockEvents.MoverStockQuotes(movers: data, quotes: $0)
            }
            .eraseToAnyPublisher()
        
    }
}

struct MoversStockQuotesExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.MoverStockQuotes
    typealias ExpeditionState = StockState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let data = event.quotes.first?.quoteResponse else { return }
        
        let topVolumeResponse = event.movers.finance.result.first(where: { $0.canonicalName == StockServiceModels.Quotes.Keys.topVolume }).map( { item in item.quotes.map { $0.symbol } }) ?? []
        
        let losersResponse = event.movers.finance.result.first(where: { $0.canonicalName == StockServiceModels.Quotes.Keys.losers }).map( { item in item.quotes.map { $0.symbol } }) ?? []
        
        let gainersResponse = event.movers.finance.result.first(where: { $0.canonicalName == StockServiceModels.Quotes.Keys.gainers }).map( { item in item.quotes.map { $0.symbol } }) ?? []
        
        let topVolumeQuotes = data.result.filter { topVolumeResponse.contains($0.symbol) }.map { $0.asStock() }.sorted(by: { $0.volume > $1.volume })
        let losersQuotes = data.result.filter { losersResponse.contains($0.symbol) }.map { $0.asStock() }.sorted(by: { $0.changePercent < $1.changePercent })
        let gainersQuotes = data.result.filter { gainersResponse.contains($0.symbol) }.map { $0.asStock() }.sorted(by: { $0.changePercent > $1.changePercent })
        
        let result = StockEvents.GlobalCategoryResult.init(topVolumeQuotes, gainersQuotes, losersQuotes)
        
        connection.request(result)
    }
}
