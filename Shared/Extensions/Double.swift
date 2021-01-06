//
//  Double.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/20/20.
//

import Foundation
import SwiftUI

extension Double {
    var format: Double {
        (self * 100).rounded() / 100
    }
    
    func randomBetween(_ secondNum: Double) -> Double{
        return Double(arc4random()) / Double(UINT32_MAX) * abs(self - secondNum) + min(self, secondNum)
    }
    
    func display(_ digits: Int = 2) -> String  {
        let customFormatter = NumberFormatter()
        customFormatter.roundingMode = .down
        customFormatter.maximumFractionDigits = digits

        return String.init(format: customFormatter.format, digits)
    }
    
    var display: String {
        display()
    }
    
    func percent(_ digits: Int = 2) -> String  {
        let customFormatter = NumberFormatter()
        customFormatter.roundingMode = .down
        customFormatter.numberStyle = .percent
        customFormatter.maximumFractionDigits = digits

        return String.init(format: customFormatter.format, digits)
    }
    
    var percent: String {
        percent()
    }
}


