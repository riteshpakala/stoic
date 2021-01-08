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
    let style: TextShadowSettings
    let selected: Bool
    
    public struct TextShadowSettings {
        let radius: CGFloat
        let offset: CGPoint
        let disable: Bool
        
        public init(radius: CGFloat, offset: CGPoint) {
            self.radius = radius
            self.offset = offset
            self.disable = false
        }
        
        public init(radius: CGFloat, offset: CGPoint, disable: Bool) {
            self.radius = radius
            self.offset = offset
            self.disable = disable
        }
        
        public static var basic: TextShadowSettings {
            .init(radius: 3, offset: .init(x: 2, y: 2), disable: false)
        }
        
        public static var disabled: TextShadowSettings {
            .init(radius: 3, offset: .init(x: 2, y: 2), disable: true)
        }
    }
    
    public init(_ text: String,
                _ color: Color = Brand.Colors.white,
                _ size: Fonts.FontSize = .subheadline,
                _ weight: Fonts.FontWeight = .regular,
                _ alignment: TextAlignment = .center,
                style: TextShadowSettings = .basic,
                selected: Bool = false) {
        self.text = text
        self.font = Fonts.live(size, weight)
        self.color = color
        self.alignment = alignment
        self.style = style
        self.selected = selected
    }
    
    public init(_ text: String,
                _ size: Fonts.FontSize = .subheadline,
                _ weight: Fonts.FontWeight = .regular,
                _ alignment: TextAlignment = .center,
                style: TextShadowSettings = .basic,
                selected: Bool = false) {
        self.text = text
        self.font = Fonts.live(size, weight)
        self.color = Brand.Colors.white
        self.alignment = alignment
        self.style = style
        self.selected = selected
    }
    
    public var body: some View {
        HStack(spacing: 0.0) {
            if alignment == .trailing {
                Spacer()
            }
            
            
            if style.disable {
                Text(text)
                    .foregroundColor(color)
                    .font(font)
                    .multilineTextAlignment(alignment)
                    .background(
                        Passthrough {
                            if self.selected {
                                Brand.Colors.black
                                    .cornerRadius(4)
                                    .padding(.top, -6)
                                    .padding(.leading, -6)
                                    .padding(.trailing, -6)
                                    .padding(.bottom, -6)
                            }
                        }
                    )
            } else {
                Text(text)
                    .granite_innerShadow(
                    color,
                    radius: style.radius,
                    offset: style.offset)
                    .font(font)
                    .multilineTextAlignment(alignment)
                    .background(
                        Passthrough {
                            if self.selected {
                                Brand.Colors.black
                                    .cornerRadius(4)
                                    .padding(.top, -6)
                                    .padding(.leading, -6)
                                    .padding(.trailing, -6)
                                    .padding(.bottom, -6)
                            }
                        }
                    )
            }
            
            
            if alignment == .leading {
                Spacer()
            }
        }
    }
}
