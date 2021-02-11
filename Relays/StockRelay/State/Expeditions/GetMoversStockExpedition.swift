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
                let movers: StockServiceModels.Movers? = data.decodeNetwork(type: StockServiceModels.Movers.self)
                
                connection.request(StockEvents.MoversData(data: movers))
                
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
        
        if let raw = data.rawData {
            coreDataInstance.save(route: state.service.movers,
                                  data: raw,
                                  responseType: .movers)
        }
        
        let symbols: [String] = data.finance.result.flatMap { item in item.quotes.map { $0.symbol } }
        
        publisher = state
            .service
            .getQuotes(symbols: symbols.uniques.joined(separator: ","))
            .replaceError(with: [])
            .map { StockEvents.MoverStockQuotes(movers: data, quotes: $0) }
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
        
        let topVolumeQuotes = data.result.filter { topVolumeResponse.contains($0.symbol) }.map { $0.asStock() }
        let losersQuotes = data.result.filter { losersResponse.contains($0.symbol) }.map { $0.asStock() }
        let gainersQuotes = data.result.filter { gainersResponse.contains($0.symbol) }.map { $0.asStock() }
        
        let result = StockEvents.GlobalCategoryResult.init(topVolumeQuotes, gainersQuotes, losersQuotes)
        
        connection.request(result)
    }
}
