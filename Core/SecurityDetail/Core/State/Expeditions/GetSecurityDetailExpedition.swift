//
//  GetSecurityDetail.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct GetSecurityDetailExpedition: GraniteExpedition {
    typealias ExpeditionEvent = SecurityDetailEvents.GetDetail
    typealias ExpeditionState = SecurityDetailState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.security.getQuote(moc: coreDataInstance) { quote in
            if let quote = quote {
                GraniteLogger.info("quote received for preview: \(quote.ticker)\n\(quote.securities.count) securities found in the quote\nupdating dependency\n quote needs update: \(quote.needsUpdate)\nself: \(String(describing: self))", .expedition, focus: true)
                
                if quote.needsUpdate {
                    updateQuote(from: state.security, connection, quote)
                } else {
                    state.quote = quote
                    
                    //Maybe we we should have a better way to check against model vs quote
                    if let modelID = connection.retrieve(\EnvironmentDependency.detail.modelID),
                       let model = quote.models.first(where: { $0.modelID == modelID }){
                        state.model = model
                        print("{TEST} hmm \(modelID)")
                    }
                }
                
                
            } else {
                updateQuote(from: state.security, connection, quote)
            }
        }
    }
    
    func updateQuote(from security: Security, _ connection: GraniteConnection, _ quote: Quote?) {
        switch security.securityType {
        case .crypto:
            connection.request(CryptoEvents.GetCryptoHistory.init(security: security, daysAgo: quote?.updateTime))
        case .stock:
            connection.request(StockEvents.GetStockHistory.init(security: security, daysAgo: quote?.updateTime))
        default:
            break
        }
    }
}

struct RefreshSecurityDetailExpedition: GraniteExpedition {
    typealias ExpeditionEvent = SecurityDetailEvents.Refresh
    typealias ExpeditionState = SecurityDetailState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.security.getQuote(moc: coreDataInstance) { quote in
            if let quote = quote {
                GraniteLogger.info("quote received for preview: \(quote.ticker)\n\(quote.securities.count) securities found in the quote\nupdating dependency\nself: \(String(describing: self))", .expedition, focus: true)
                
                if quote.needsUpdate {
                    updateQuote(from: state.security, connection, quote)
                } else {
                    state.quote = quote
                    
                    if let model = state.quote?.models.first(where: { $0.assetID == state.modelID }) {
                        state.model = model
                    }
                }
                
                
            } else {
                updateQuote(from: state.security, connection, quote)
            }
        }
    }
    
    func updateQuote(from security: Security, _ connection: GraniteConnection, _ quote: Quote?) {
        switch security.securityType {
        case .crypto:
            connection.request(CryptoEvents.GetCryptoHistory.init(security: security, daysAgo: quote?.updateTime))
        case .stock:
            connection.request(StockEvents.GetStockHistory.init(security: security, daysAgo: quote?.updateTime))
        default:
            break
        }
    }
}
