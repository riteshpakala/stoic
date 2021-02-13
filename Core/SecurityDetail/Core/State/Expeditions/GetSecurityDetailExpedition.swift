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
                GraniteLogger.info("quote received for preview: \(quote.ticker)\nupdating dependency\nself: \(String(describing: self))", .expedition, focus: true)
                
                if quote.needsUpdate {
                    updateQuote(from: state.security, connection, quote)
                }
                
                state.quote = quote
                
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
