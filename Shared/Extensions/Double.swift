//
//  Double.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/20/20.
//

import Foundation

extension Double {
    var format: Double {
        (self * 100).rounded() / 100
    }
    
    func randomBetween(_ secondNum: Double) -> Double{
        return Double(arc4random()) / Double(UINT32_MAX) * abs(self - secondNum) + min(self, secondNum)
    }
}
