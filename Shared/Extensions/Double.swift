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
        
        return String.init(format: customFormatter.format, self)
    }
    
    var display: String {
        String(format: "%.2f", self)
    }
    
    func percent(_ digits: Int = 2) -> String  {
        let customFormatter = NumberFormatter()
        customFormatter.roundingMode = .down
        customFormatter.numberStyle = .percent
        customFormatter.maximumFractionDigits = digits
        
        return String.init(format: customFormatter.format, self)
    }
    
    var percent: String {
        String(format: "%.2f%", self*100)
    }
    
    var abbreviate: String {
        let number = self
        let thousand = number / 1000
        let million = number / 1000000
        
        if million >= 1.0 {
            return String(format: "%.2f%m", million)
        }
        else if thousand >= 1.0 {
            return String(format: "%.2f%k", thousand)
        }
        else {
            return String(format: "%.2f%", self*100)
        }
    }
}


