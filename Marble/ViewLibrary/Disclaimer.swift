//
//  Disclaimer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

class Disclaimer: NSObject, Codable {
    public lazy var label: UILabel = {
        let view: UILabel = .init()
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.marbleBrown
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        return view
        
    }()
    public var value: String
    
    public init(value: String) {
        self.value = value
        super.init()
        print("{ANNOUNCEMENT} {DISCL} \(value)")
        label.text = value
    }
}
