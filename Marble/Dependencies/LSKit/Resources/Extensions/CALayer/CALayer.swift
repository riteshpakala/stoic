//
//  CALayer.swift
//  DeepCrop
//
//  Created by Ritesh Pakala on 3/6/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, stretchBy : CGFloat = 0.0, shrinkRightBy : CGFloat = 0.0, growBottomBy : CGFloat = 0.0) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0.0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - (thickness - 0.5), width: frame.width + 0.75 + growBottomBy, height: thickness)
        case .left:
            border.frame = CGRect(x: -0.25, y: 0 - (stretchBy/2), width: thickness, height: frame.height + stretchBy)
        case .right:
            border.frame = CGRect(x: (frame.width - thickness) + 0.5, y: 0.5, width: thickness, height: frame.height - shrinkRightBy)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
    
    func addAntiAliasingBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, stretchBy : CGFloat = 0.0) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - (thickness), width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0 - (stretchBy/2), width: thickness, height: frame.height + stretchBy)
        case .right:
            border.frame = CGRect(x: (frame.width - thickness), y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}
