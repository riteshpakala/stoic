//
//  BasicSliderComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct BasicSliderComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<BasicSliderCenter, BasicSliderState> = .init()

    public init() {}
    public var body: some View {
        VStack {
            ValueSlider(value: _state.number,
                        onEditingChanged: { changed in
                            if !changed {
                                sendEvent(BasicSliderEvents.Value(data: state.number), contact: true)
                            }
                        })
                .frame(height: 64)
                .valueSliderStyle(
                    HorizontalValueSliderStyle(
                        track: HorizontalValueTrack(
                            view: LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Brand.Colors.purple]),
                            startPoint: .leading,
                            endPoint: .trailing),
                            mask: RoundedRectangle(cornerRadius: 8)
                        )
                        .frame(height: 64)
                        .cornerRadius(3),
                        thumb: RoundedRectangle(cornerRadius: 10).foregroundColor(Brand.Colors.white),
                        thumbSize: CGSize(width: 16, height: 42)
                    )
                )
            
        }.padding(.leading, Brand.Padding.large).padding(.trailing, Brand.Padding.large)
    }
}

public struct HalfCapsule: View, InsettableShape {
    private let inset: CGFloat

    public func inset(by amount: CGFloat) -> HalfCapsule {
        HalfCapsule(inset: self.inset + amount)
    }
    
    public func path(in rect: CGRect) -> Path {
        let width = rect.size.width - inset * 2
        let height = rect.size.height - inset * 2
        let heightRadius = height / 2
        let widthRadius = width / 2
        let minRadius = min(heightRadius, widthRadius)
        return Path { path in
            path.move(to: CGPoint(x: width, y: 0))
            path.addArc(center: CGPoint(x: minRadius, y: minRadius), radius: minRadius, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 180), clockwise: true)
            path.addArc(center: CGPoint(x: minRadius, y: height - minRadius), radius: minRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 90), clockwise: true)
            path.addLine(to: CGPoint(x: width, y: height))
            path.closeSubpath()
        }.offsetBy(dx: inset, dy: inset)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            self.path(in: CGRect(x: 0, y: 0, width: geometry.size.width, height: geometry.size.height))
        }
    }
    
    public init(inset: CGFloat = 0) {
        self.inset = inset
    }
}
