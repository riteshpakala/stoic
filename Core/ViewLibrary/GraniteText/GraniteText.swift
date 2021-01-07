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
    let alignment: TextAlignment
    
    public init(_ text: String,
                _ color: Color = Brand.Colors.white,
                _ size: Fonts.FontSize = .subheadline,
                _ weight: Fonts.FontWeight = .regular,
                _ alignment: TextAlignment = .center) {
        self.text = text
        self.font = Fonts.live(size, weight)
        self.color = color
        self.alignment = alignment
    }
    
    public init(_ text: String,
                _ size: Fonts.FontSize = .subheadline,
                _ weight: Fonts.FontWeight = .regular,
                _ alignment: TextAlignment = .center) {
        self.text = text
        self.font = Fonts.live(size, weight)
        self.color = Brand.Colors.white
        self.alignment = alignment
    }
    
    public var body: some View {
        HStack(spacing: 0.0) {
            if alignment == .trailing {
                Spacer()
            }
            
            Text(text)
                .granite_innerShadow(
                color,
                radius: 3,
                offset: .init(x: 2, y: 2))
                .font(font)
            
            if alignment == .leading {
                Spacer()
            }
        }
    }
}
