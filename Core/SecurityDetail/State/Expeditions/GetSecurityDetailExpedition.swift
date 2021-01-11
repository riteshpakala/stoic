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
        
        
        switch state.kind {
        case .expanded(let payload),
             .preview(let payload),
             .floor(let payload):
            guard let security = payload.object as? Security else { return }
        
            coreDataInstance.getQuotes { result in
                if let quote = result.first(where: { $0.ticker == security.ticker &&
                                                $0.intervalType == .day }) {
                    
                    state.quote = quote
                } else {
                    guard let isFetching = connection.retrieve(\EnvironmentDependency.detail.isFetching),
                          !isFetching else {
                        return
                    }
                    connection.update(\EnvironmentDependency.detail.isFetching, value: true)
                    
                    connection.request(StockEvents.GetStockHistory.init(ticker: security.ticker))
                }
            }
            break
        }
    }
}
