//
//  TapAndLongPressModifier.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/29/21.
//

import Foundation
import SwiftUI

public struct TapAndLongPressModifier: ViewModifier {
    @State private var isLongPressing = false
    let tapAction: (()->())
    let longPressAction: (()->())?
    public init(tapAction: @escaping (()->()),
                longPressAction: (()->())? = nil) {
        self.tapAction = tapAction
        self.longPressAction = longPressAction
    }
    public func body(content: Content) -> some View {
        content
            .scaleEffect(isLongPressing ? 0.95 : 1.0)
            .onLongPressGesture(minimumDuration: 1.0, pressing: { (isPressing) in
                withAnimation {
                    isLongPressing = isPressing
                }
            }, perform: {
                longPressAction?()
            })
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        tapAction()
                    }
            )
    }
}
