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
    @State var pointX1 = 0.5
    @State var pointY1 = 0.5
    public init() {}
    
    public var body: some View {
        PointSlider(x: $pointX1, y: $pointY1)
            .frame(height: 256)
            .pointSliderStyle(
                RectangularPointSliderStyle(
                    track:
                        ZStack {
                            RadialGradient(gradient: Gradient(colors: [Brand.Colors.yellow, Brand.Colors.purple]), center: .center, startRadius: 1.0, endRadius: 300)
//                            LinearGradient(gradient: Gradient(colors: [Brand.Colors.yellow, Brand.Colors.purple]), startPoint: .leading, endPoint: .trailing)
//                            LinearGradient(gradient: Gradient(colors: [.white, .clear]), startPoint: .bottom, endPoint: .top).blendMode(.hardLight)
                        }
                        .cornerRadius(24),
                    thumbSize: CGSize(width: 48, height: 48)
                )
            )
    }
}
