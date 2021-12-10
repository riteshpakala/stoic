//
//  SentimentSliderComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct SentimentSliderComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<SentimentSliderCenter, SentimentSliderState> = .init()
    
    public init() {}
    
    public var body: some View {
        PointSlider(x: _state.pointX1,
                    y: _state.pointY1,
                    onEditingChanged: { changed in
                        sendEvent(SentimentSliderEvents.Value(
                                    x: state.pointX1,
                                    y: state.pointY1,
                                    isActive: changed,
                                    date: state.date), .contact)
                    })
            .frame(height: 144)
            .pointSliderStyle(
                RectangularPointSliderStyle(
                    track:
                        ZStack {
                            RadialGradient(gradient: Gradient(colors: [Brand.Colors.yellow, Brand.Colors.purple]), center: .center, startRadius: 1.0, endRadius: 300)
//                            LinearGradient(gradient: Gradient(colors: [Brand.Colors.yellow, Brand.Colors.purple]), startPoint: .leading, endPoint: .trailing)
//                            LinearGradient(gradient: Gradient(colors: [.white, .clear]), startPoint: .bottom, endPoint: .top).blendMode(.hardLight)
                        }
                        .cornerRadius(24),
                    thumbSize: CGSize(width: 36, height: 36)
                )
            )
    }
}
