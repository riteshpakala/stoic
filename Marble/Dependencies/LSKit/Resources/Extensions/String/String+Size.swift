//
//  String+Size.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/2/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func size(forFont font: UIFont) -> CGSize {
        let size = (self as NSString)
        .size(withAttributes: [NSAttributedString.Key.font: font])
        
        return .init(
            width: ceil(size.width),
            height: ceil(size.height))
    }
}
