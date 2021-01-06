//
//  TextViews.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/6/21.
//

import Foundation
import SwiftUI

public struct GraniteText: View {
    let text: String
    let font: Font
    let color: Color
    
    public init(_ text: String,
                _ color: Color = Brand.Colors.white,
                _ size: Fonts.FontSize = .subheadline,
                _ weight: Fonts.FontWeight = .regular) {
        self.text = text
        self.font = Fonts.live(size, weight)
        self.color = color
    }
    
    public init(_ text: String,
                _ size: Fonts.FontSize = .subheadline,
                _ weight: Fonts.FontWeight = .regular) {
        self.text = text
        self.font = Fonts.live(size, weight)
        self.color = Brand.Colors.white
    }
    
    public var body: some View {
        Text(text)
            .granite_innerShadow(
            color,
            radius: 3,
            offset: .init(x: 2, y: 2))
            .multilineTextAlignment(.leading)
            .font(font)
    }
}
