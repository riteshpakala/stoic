//
//  GlobalStyle.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/20/20.
//

import Foundation
import SwiftUI

public struct Brand {
    public struct Colors {
        public static var marble: Color = .init(hex: "#A19A8E")
        public static var grey: Color = .init(hex: "#808080")
        public static var white: Color = .init(hex: "#FFFFFF")
        public static var green: Color = .init(hex: "#39FF14")
        public static var red: Color = .init(hex: "#D90000")
        public static var purple: Color = .init(hex: "#EC6CFF")
        public static var yellow: Color = .init(hex: "#FFCD00")
        public static var black: Color = .init(hex: "#121212")
    }
    
    public struct Gradients {
        public static var marbleGradient: LinearGradient {
            return .init(
                gradient: .init(
                    colors: [Color(hex: "#CFCAC1"),
                             Color(hex: "#A19A8E")]),
                startPoint: .init(x: 0.0, y: 0.0),
                endPoint: .init(x: 0.48, y: 0.48))
        }
    }
    
    public struct Padding {
        public static var large: CGFloat = 24
        public static var medium: CGFloat = 12
        public static var small: CGFloat = 6
        public static var xSmall: CGFloat = 3
    }
}
