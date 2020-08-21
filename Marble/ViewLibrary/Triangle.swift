//
//  Triangle.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/24/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

class TriangleView : UIView {
    let color: UIColor
    let direction: UIRectEdge
    init(
        frame: CGRect,
        color: UIColor,
        direction: UIRectEdge = .bottom) {
        self.color = color
        self.direction = direction
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        
        
        if direction == .bottom {
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        } else if direction == .right {
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY/2))
            context.addLine(to: CGPoint(x: (rect.minX), y: rect.maxY))
        } else if direction == .left {
            context.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY/2))
            context.addLine(to: CGPoint(x: (rect.maxX), y: rect.maxY))
        }
        
        context.closePath()
        context.setFillColor(color.cgColor)
        context.fillPath()
    }
    
    func rotate(by angle: CGFloat = CGFloat.pi/2) {
        UIView.animate(withDuration: 0.24, delay: 0.0, options: .curveEaseIn, animations: {
            if self.transform == .identity {
                self.transform = self.transform.rotated(by: angle)
            } else {
                self.transform = .identity
            }
        }) { finished in
            
        }
    }
}
