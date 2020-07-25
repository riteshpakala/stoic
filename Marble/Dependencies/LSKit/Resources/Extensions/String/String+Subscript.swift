//
//  String+Subscript.swift
//  Wonder
//
//  Created by Ritesh Pakala on 3/28/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import UIKit

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    func setLetterSpacing(to: CGFloat) -> NSAttributedString{
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.kern: to])
    }
    
    func writeToDeepCropLog(){
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("deepcrop_log.txt")
            
            //writing
            do {
                try self.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
            
        }
    }
}
