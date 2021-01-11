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
public class SecurityDetailState: GraniteState {
    let kind: SecurityDetailType
    var quote: Quote? = nil
    
    public init(_ kind: SecurityDetailType) {
        self.kind = kind
    }
    
    public required init() {
        self.kind = .preview(.init(object: nil))
    }
}

public class SecurityDetailCenter: GraniteCenter<SecurityDetailState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(SecurityDetailEvents.GetDetail(), .dependant),
        ]
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetSecurityDetailExpedition.Discovery(),
            SecurityDetailResultExpedition.Discovery()
        ]
    }
    
    var security: Security {
        switch state.kind {
        case .preview(let payload),
             .expanded(let payload),
             .floor(let payload):
            return (payload.object as? Security) ?? EmptySecurity()
        }
    }
    
    var loaded: Bool {
        self.state.quote != nil
    }
}
