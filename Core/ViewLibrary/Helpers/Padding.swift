//
//  Padding.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/6/21.
//

import Foundation
import SwiftUI
import GraniteUI

public struct PaddingVertical: View {
    let height: CGFloat
    let color: Color
    
    public init(_ height: CGFloat = Brand.Padding.small,
                _ color: Color = .black) {
        self.height = height
        self.color = color
    }
    
    public var body: some View {
        Rectangle().frame(maxWidth: .infinity,
                          minHeight: height,
                          idealHeight: height,
                          maxHeight: height).foregroundColor(color)
    }
}

public struct PaddingHorizontal: View {
    let width: CGFloat
    let color: Color
    
    public init(_ width: CGFloat = Brand.Padding.small,
                _ color: Color = .black) {
        self.width = width
        self.color = color
    }
    
    public var body: some View {
        Rectangle().frame(minWidth: width,
                          idealWidth: width,
                          maxWidth: width,
                          maxHeight: .infinity).foregroundColor(color)
    }
}
