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
            if state.isExpanded {
                guard let quote = connection.retrieve(\EnvironmentDependency.detail.quote) else {
                    return
                }
                if quote?.contains(security: state.security) == false {
                    connection.update(\EnvironmentDependency.detail.stage, value: .none)
                    
                    GraniteLogger.info("quote not compatible\nrequesting a new quote\nself:\(self)", .expedition)
                } else {
                    //Should be the final stage of the SecurityDetail in its EXPANDED
                    //state.
                    //
                    //The question that begs to differ, is how should we update the stage
                    //without another draw call that will cause the command to send an
                    //object request
                    //
                    GraniteLogger.info("quote found\nrequesting a detail generation\nself:\(self)", .expedition)
                    state.quote = quote
                }
            } else {
                state.security.getQuote(moc: coreDataInstance) { quote in
                    if let quote = quote {
                        GraniteLogger.info("quote received for preview: \(quote.ticker)\nupdating dependency\nself:\(self)", .expedition)
                        state.quote = quote
                        
                    } else {
                        //This will cause a repeat call of the stock that triggered it
                        //The stage if entering an EXPANDED detail before entering the floor
                        //or any PREVIEW detail type, will be in a "LOADED" stage, which requires
                        //incase of redraws when in the EXPANDED state. So, we must handle this
                        //with a reset once this expedition is recalled.
                        //
                        //???: There could be a solution running expeditions asynchronously,
                        //to complete jobs and then recontinue when necessary
                        GraniteLogger.info("no quote found, need to re-fetch the history of the \(state.securityType)\nself:\(self)", .expedition)
                        connection.update(\EnvironmentDependency.detail.stage, value: .none)
                    }
                }
            }
            
            break
        default:
            state.security.getQuote(moc: coreDataInstance) { quote in
                if let quote = quote {
                    GraniteLogger.info("quote received: \(quote.ticker)\nupdating dependency\nself:\(self)", .expedition)
                    if state.isExpanded {
                        connection.update(\EnvironmentDependency.detail.quote, value: quote)
                    } else {
                        state.quote = quote
                    }
                } else if state.isExpanded {
                    GraniteLogger.info("quote was not found\nfetching quote/\(state.securityType) history\nself:\(self)", .expedition)
                    guard stage == .none else {
                        GraniteLogger.error("fetching quote/\(state.securityType) history failed\nstage is not none - \(stage)\nself:\(self)", .expedition)
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
