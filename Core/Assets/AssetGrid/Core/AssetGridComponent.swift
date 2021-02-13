//
//  AssetGridComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct AssetGridComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<AssetGridCenter, AssetGridState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            AssetGridItemContainerComponent(state: .init(state.type,
                                                         leadingPadding: state.leadingPadding))
                .listen(to: command)
                .payload(state.payload)
                .frame(
//                     minWidth: 300 + Brand.Padding.large,
//                       idealWidth: 414 + Brand.Padding.large,
                    maxWidth: .infinity,//420 + Brand.Padding.large,
//                       minHeight: 48 * 5,
//                       idealHeight: 50 * 5,
                    maxHeight: .infinity,//75 * 5,
                    alignment: .leading)
        }
    }
}

//MARK: -- Empty State Settings
extension AssetGridComponent {
    
    public var emptyText: String {
        switch state.context {
        case .holdings,
             .portfolio:
            return "add & save a security\nfor easy access"
        case .floor:
            return "add & save\na security to\nyour trading floor"
        case .tonalBrowser:
            return "create & save a tonal model\nfor it to appear here"
        case .topVolume,.winners,.losers:
            return "fetching..."
        default:
            return ""
        }
        
    }
    
    public var isDependancyEmpty: Bool {
        switch state.context {
        case .holdings,
             .portfolio,
             .floor,
             .topVolume,
             .winners,
             .losers,
             .winnersAndLosers:
            let securities: [Security]? = (state.payload?.object as? [Security])
            return securities == nil || securities?.isEmpty == true
        case .tonalBrowser:
            return (state.payload?.object as? [TonalModel])?.isEmpty == true
        default:
            return false
        }
    }
    
    public var emptyPayload: GranitePayload? {
        switch state.context {
        case .holdings,
             .portfolio,
             .floor:
            return .init(object: [Brand.Colors.yellow, Brand.Colors.redBurn])
        case .tonalBrowser:
            return .init(object: [Brand.Colors.redBurn, Brand.Colors.yellow])
        default:
            return nil
        }
    }
    
}
