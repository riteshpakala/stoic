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
        
        
        guard let stage = connection.retrieve(\EnvironmentDependency.detail.stage) else {
            return
        }
        
        switch stage {
        case .loaded:
            guard let quote = connection.retrieve(\EnvironmentDependency.detail.quote) else {
                return
            }
            if quote?.contains(security: state.security) == false {
                print("{TEST} shoule be generating new 1")
                connection.update(\EnvironmentDependency.detail.stage, value: .none)
            } else {
                print("{TEST} generating ----")
                state.quote = quote
            }
            
            break
        default:
            state.security.getQuote(moc: coreDataInstance) { quote in
                if let quote = quote {
                    print("{TEST} quote received \(quote.intervalType)")
                    if state.isExpanded {
                        connection.update(\EnvironmentDependency.detail.quote, value: quote)
                    } else {
                        state.quote = quote
                    }
                } else if state.isExpanded {
                    print("{TEST} quote was not found")
                    guard stage == .none else {
                        return
                    }
                    connection.update(\EnvironmentDependency.detail.stage, value: .fetching)
                    
                    switch state.securityType {
                    case .crypto:
                        connection.request(CryptoEvents.GetCryptoHistory.init(security: state.security))
                    case .stock:
                        connection.request(StockEvents.GetStockHistory.init(security: state.security))
                    default:
                        break
                    }
                }
            }
        }
    }
}
