//
//  SecurityDetailState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum SecurityDetailType: ID, Hashable, Equatable {
    case expanded(GranitePayload)
    case preview(GranitePayload)
    case floor(GranitePayload)
}
public enum SecurityDetailStage {
    case failedFetching
    case loaded
    case fetched
    case fetching
    case none
}
public class SecurityDetailState: GraniteState {
    let kind: SecurityDetailType
    var quote: Quote? = nil
    
    var security: Security {
        switch kind {
        case .expanded(let payload),
             .preview(let payload),
             .floor(let payload):
            return payload.object as? Security ?? EmptySecurity()
        }
    }
    
    var securityType: SecurityType {
        security.securityType
    }
    
    var isExpanded: Bool {
        switch kind {
        case .expanded:
            return true
        default:
            return false
        }
    }
    
    var modelID: String = ""
    var model: TonalModel? = nil
    var tune: SentimentOutput = .neutral
    var currentPrediction: TonalPrediction = .zero
    var currentPredictionPlotData: GraphPageViewModel.PlotData? = nil
    
    public init(_ kind: SecurityDetailType) {
        self.kind = kind
        self.quote = nil
        self.modelID = ""
    }
    
    public init(_ kind: SecurityDetailType,
                quote: Quote? = nil,
                modelID: String = "") {
        self.kind = kind
        self.quote = quote
        self.modelID = modelID
    }
    
    public init(_ kind: SecurityDetailType,
                quote: Quote? = nil,
                model: TonalModel? = nil) {
        self.kind = kind
        self.quote = quote
        self.model = model
    }
    
    public required init() {
        self.kind = .preview(.init(object: nil))
    }
}

public class SecurityDetailCenter: GraniteCenter<SecurityDetailState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()

    @GraniteDependency
    var detailDependency: DetailDependency
    
    @GraniteDependency
    var envDependency: EnvironmentDependency
    
    public override var links: [GraniteLink] {
        [
            .onAppear(SecurityDetailEvents.GetDetail()),
        ]
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetSecurityDetailExpedition.Discovery(),
            RefreshSecurityDetailExpedition.Discovery(),
            StockDetailResultExpedition.Discovery(),
            CryptoDetailResultExpedition.Discovery()
        ]
    }
    
    var security: Security {
        state.quote?.latestSecurity ?? state.security
    }
    
    var loadedQuote: Bool {
        state.quote != nil
    }
}
