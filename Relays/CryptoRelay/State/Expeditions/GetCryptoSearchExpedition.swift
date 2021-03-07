//
//  GetCryptoSearchExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/12/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetCryptoSearchExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.Search
    typealias ExpeditionState = CryptoState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        let route = state.service.list
        
        let moc = coreDataInstance
        
        let responses = moc.checkSearchCache(forRoute: route)
        if let searchResponses = responses {
            connection.request(CryptoEvents.SearchDataResult.init(event.query, data: searchResponses))
        } else {
            connection.request(CryptoEvents.SearchBackend(event.query))
        }
    }
}

struct GetCryptoSearchBackendExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.SearchBackend
    typealias ExpeditionState = CryptoState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        publisher = state
            .service
            .getList()
            .replaceError(with: [])
            .map { [weak coreDataInstance] result in
                
                guard let instance = coreDataInstance else { return CryptoEvents.SearchDataResult(event.query, data: []) }
                
                result.forEach { response in
                    response.save(moc: instance)
                }
                
                return CryptoEvents.SearchDataResult(event.query, data: result) }
            .eraseToAnyPublisher()
    }
}

struct GetCryptoSearchResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.SearchDataResult
    typealias ExpeditionState = CryptoState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        var distances: [Int: [SearchResponse]] = [:]
        event.data.forEach { response in
            let distance = getLevDistance(response.entityDescription, forQuery: event.query)
            
            
            if distance < 4 {
                if distances.keys.contains(distance) {
                    distances[distance]?.append(response)
                } else {
                    distances[distance] = [response]
                }
            }
        }
        
        for i in 0..<(distances.keys.max() ?? 0) {
            let candidates = distances[i]
            distances[i] = candidates?.sorted(by: { $0.entityDescription.count < $1.entityDescription.count })
        }
        
        let candidates: [SearchResponse] = distances.flatMap { $0.value.prefix(4) }
        
        connection.request(CryptoEvents.GetSearchQuote.init(data: candidates))
    }
    
    // return minimum value in a list of Ints
    func minFrom(_ numbers: Int...) -> Int {
        return numbers.reduce(numbers[0], {$0 < $1 ? $0 : $1})
    }

    func getLevDistance(_ aStr: String, forQuery query: String) -> Int {
        let components = aStr.components(separatedBy: .whitespacesAndNewlines)
        
        var distances: [Int] = []
        components.forEach { component in
            distances.append(levenshtein(component, query))
        }
        
        return distances.min() ?? 1200000
    }
    func levenshtein(_ aStr: String, _ bStr: String) -> Int {
        // create character arrays
        let a = Array(aStr)
        let b = Array(bStr)

        // initialize matrix of size |a|+1 * |b|+1 to zero
        var dist: [[Int]] = []
        for _ in 0...a.count {
            dist.append([Int](repeating: 0, count: b.count + 1))
        }

        // 'a' prefixes can be transformed into empty string by deleting every char
        for i in 1...a.count {
            dist[i][0] = i
        }

        // 'b' prefixes can be created from empty string by inserting every char
        for j in 1...b.count {
            dist[0][j] = j
        }

        for i in 1...a.count {
            for j in 1...b.count {
                if a[i-1] == b[j-1] {
                    dist[i][j] = dist[i-1][j-1]  // noop
                } else {
                    dist[i][j] = minFrom(
                        dist[i-1][j] + 1,  // deletion
                        dist[i][j-1] + 1,  // insertion
                        dist[i-1][j-1] + 1  // substitution
                    )
                }
            }
        }

        return dist[a.count][b.count]
    }
}

struct GetCryptoSearchQuotesExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.GetSearchQuote
    typealias ExpeditionState = CryptoState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let query: String = event.data.compactMap { $0.id }.joined(separator: ",")
        let data = event.data
        publisher = state
            .service
            .getQuotes(symbols: query)
            .replaceError(with: [])
            .map { result in
                var crypto: [CryptoCurrency] = []
                for item in result {
                    if let symbol = data.first(where: { $0.entityDescription.lowercased() == item.name.lowercased()}) {
                        
                        crypto.append(.init(ticker: symbol.symbolName,
                                            date: item.lastUpdatedAt.date(),
                                            open: 0.0,
                                            close: item.price,
                                            high: 0.0,
                                            low: 0.0,
                                            volumeBTC: 0.0,
                                            volume: item.volume24H,
                                            changePercent: item.change24h/100,
                                            changeAbsolute: item.price * (item.change24h/100),
                                            interval: .hour,
                                            exchangeName: symbol.exchangeName,
                                            name: item.name,
                                            hasStrategy: false,
                                            hasPortfolio: false))
                        
                    }
                }
                
                return CryptoEvents.SearchResult(result: crypto) }
            .eraseToAnyPublisher()
    }
}
