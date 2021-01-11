//
//  FloorComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct FloorComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<FloorCenter, FloorState> = .init()
    
    public init() {}
    
    var layout: [GridItem] {
        .init(repeating: GridItem(.flexible()), count: maxWidth)
    }
    
    var maxWidth: Int {
        Array(state.activeSecurities.map { $0.count }).max() ?? 0
    }
    
    var maxHeight: Int {
        state.activeSecurities.count
    }
    
    func getSecurity(row: Int, col: Int) -> Security? {
        return state.activeSecurities[row][col]
    }
    
    public var body: some View {
        ZStack {
            HStack(spacing: Brand.Padding.small) {
                //Max Windows Height
                ForEach(0..<maxHeight, id: \.self) { col in
                    VStack(spacing: Brand.Padding.small) {
                        ForEach(0..<maxWidth, id: \.self) { row in
                            if row < state.activeSecurities.count,
                               col < state.activeSecurities[row].count{
                                
                                if let security = getSecurity(row: row, col: col) {
                                    SecurityDetailComponent(state: .init(.floor(.init(object: security))))
                                        .share(.init(dep(\.hosted,
                                                     FloorCenter.route))).background(Brand.Colors.black)
                                } else {
                                    HStack {
                                        Spacer()
                                        Circle()
                                            .foregroundColor(Brand.Colors.marble).overlay(
                                            
                                                GraniteText("+", Brand.Colors.black, .title3, .bold)
                                            
                                            )
                                            .frame(width: 42, height: 42)
                                            .onTapGesture(perform: sendEvent(FloorEvents.AddToFloor(location: CGPoint.init(row, col))))
                                        Spacer()
                                    }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Brand.Colors.black)
                                }
                            }
                        }
                    }
                }
            }
            .background(Color.black)
            
            switch state.floorStage {
            case .adding(_):
                VStack {
                    HoldingsComponent(state: inject(\.envDependency,
                                                    target: \.holdingsFloor))
                        .share(.init(dep(\.hosted,
                                                         FloorCenter.route)))
                }.frame(maxWidth: 400, maxHeight: 500)
                .background(Brand.Colors.black)
                .cornerRadius(6)
                .shadow(color: Color.black, radius: 6, x: 4, y: 4)
            default:
                EmptyView.init().hidden()
            }
        }
    }
}
