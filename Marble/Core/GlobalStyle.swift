//
//  Services+Style.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

public struct GlobalStyle {
    public struct Colors {
        static let green: UIColor = UIColor(hex: "#39FF14")
        static let black: UIColor = UIColor(hex: "#121212")
        static let purple: UIColor = UIColor(hex: "#EC6CFF")
        static let yellow: UIColor = UIColor(hex: "#ECE300")
        static let orange: UIColor = UIColor(hex: "#FFCD00")
        static let blue: UIColor = UIColor(hex: "#00FFFD")
        static let red: UIColor = UIColor(hex: "#AA1313")
        static let marbleBrown: UIColor = UIColor(hex: "#786E5D")
        static let graniteGray: UIColor = UIColor(hex: "#808080")
        
    }
    public struct Fonts {
        public enum FontSize: CGFloat {
            case Xlarge = 27
            case large = 24
            case medium = 18
            case subMedium = 16
            case small = 12
            case footnote = 7
        }
        public enum FontWeight: String {
            case bold = "Bold"
            case boldOblique = "BoldOblique"
            case oblique = "Oblique"
        }
        
        let largeFontSize: CGFloat = 24
        let mediumFontSize: CGFloat = 18
        let smallFontSize: CGFloat = 12
        
        public static func courier(
            _ size: FontSize,
            _ weight: FontWeight) -> UIFont {
            
            return UIFont(
                name: "Courier-\(weight.rawValue)",
                size: size.rawValue) ??
                UIFont.systemFont(
                    ofSize: size.rawValue)
        }
    }
    
    static let largePadding: CGFloat = 24
    static let padding: CGFloat = 12
    static let spacing: CGFloat = 4
    
    static func addShadow(toView view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
    }
}
