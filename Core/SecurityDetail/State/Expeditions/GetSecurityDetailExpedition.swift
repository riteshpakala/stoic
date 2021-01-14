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
                print("{TEST} quote received")
                state.quote = quote
                
//                    //DEV:
//                    let indicator = TonalServiceModels.Indicators.init(security,
//                                                                       with: quote)
//
//                    indicator.stochastic
            } else {
                print("{TEST} quote was not found")
                guard let stage = connection.retrieve(\EnvironmentDependency.detail.stage),
                      stage == .none else {
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
