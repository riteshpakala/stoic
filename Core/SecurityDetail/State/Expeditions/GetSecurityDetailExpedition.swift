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
                connection.update(\EnvironmentDependency.detail.stage, value: .none)
                
                GraniteLogger.info("quote not compatible\nrequesting a new quote\nself:\(self)", .expedition, focus: true)
            } else {
                GraniteLogger.info("quote found\nrequesting a detail generation\nself:\(self)", .expedition, focus: true)
                state.quote = quote
            }
            
            break
        default:
            state.security.getQuote(moc: coreDataInstance) { quote in
                if let quote = quote {
                    GraniteLogger.info("quote received\nupdating dependency\nself:\(self)", .expedition, focus: true)
                    if state.isExpanded {
                        connection.update(\EnvironmentDependency.detail.quote, value: quote)
                    } else {
                        state.quote = quote
                    }
                } else if state.isExpanded {
                    GraniteLogger.info("quote was not found\nfetching quote/\(state.securityType) history\nself:\(self)", .expedition, focus: true)
                    guard stage == .none else {
                        GraniteLogger.error("fetching quote/\(state.securityType) history failed\nstage is not none - \(stage)\nself:\(self)", .expedition, focus: true)
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
