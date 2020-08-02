//
//  Emitters.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/29/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func thinkingEmitter(
        forSize size: CGSize?,
        emitterSize: CGFloat = 1,
        color: UIColor = .white) {
        
        let explosionLayer = CAEmitterLayer()
        explosionLayer.emitterPosition = CGPoint(
            x: (size?.width ?? self.bounds.size.width) / 2,
            y: (size?.height ?? self.bounds.size.height) / 2)
        explosionLayer.emitterShape = CAEmitterLayerEmitterShape.circle
        explosionLayer.emitterMode = CAEmitterLayerEmitterMode.outline
        explosionLayer.emitterSize = CGSize(width: emitterSize, height: 0)
        explosionLayer.renderMode = CAEmitterLayerRenderMode.oldestLast
        
        let bubble = CAEmitterCell()
        bubble.contents = UIImage(named: "emitter.particle")?.cgImage
        bubble.scale = 0.2
        bubble.alphaRange = 0.2
        bubble.alphaSpeed = -0.8
        bubble.birthRate = 120
        bubble.lifetime = 0.5
        bubble.velocity = 24
        bubble.velocityRange = 5
        bubble.color = color.cgColor
        
        explosionLayer.emitterCells = [bubble]
        self.layer.addSublayer(explosionLayer)
    }
}
