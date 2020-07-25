//
//  Int.swift
//  DeepCrop
//
//  Created by Ritesh Pakala on 2/20/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import Foundation

extension Int {
    func randomBetween(_ secondNum: Int) -> Int{
        guard secondNum > 0 else { return 0 }
        
        return Int.random(in: self..<secondNum)
    }
}
