//
//  BrowserModelDataCardView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/8/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import Granite
import UIKit


public class BrowserModelDataCardView: GraniteView {
    
    var swipeableProperties: SwipeableProperties
    
    public init() {
        swipeableProperties = .init()
        super.init(frame: .zero)
        
        let panGestureRecognizer = UIPanGestureRecognizer(
                   target: self,
                   action: #selector(BrowserModelDataCardView.panGestureRecognized(_:)))
        swipeableProperties.panGestureRecognizer = panGestureRecognizer
        addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BrowserModelDataCardView {
    // MARK: - Pan Gesture Recognizer

    @objc private func panGestureRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
        swipeableProperties.panGestureTranslation = gestureRecognizer.translation(in: self)

        switch gestureRecognizer.state {
        case .began:
            let initialTouchPoint = gestureRecognizer.location(in: self)
            let newAnchorPoint = CGPoint(x: initialTouchPoint.x / bounds.width, y: initialTouchPoint.y / bounds.height)
            let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
            let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
            layer.anchorPoint = newAnchorPoint
            layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)

            layer.rasterizationScale = UIScreen.main.scale
            layer.shouldRasterize = true
        case .changed:
            
            var transform = CATransform3DIdentity
            
            if SwipeableProperties.cardViewRotationEnabled {
                let rotationStrength = min(swipeableProperties.panGestureTranslation.x / frame.width, SwipeableProperties.maximumRotation)
                let rotationAngle = SwipeableProperties.animationDirectionY * SwipeableProperties.rotationAngle * rotationStrength

                transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            }
            transform = CATransform3DTranslate(transform, swipeableProperties.panGestureTranslation.x, swipeableProperties.panGestureTranslation.y, 0)
            layer.transform = transform
        case .ended:
            endedPanAnimation()
            layer.shouldRasterize = false
        default:
            resetCardViewPosition()
            layer.shouldRasterize = false
        }
    }

    private var dragDirection: SwipeDirection? {
        let normalizedDragPoint = swipeableProperties.panGestureTranslation.normalizedDistanceForSize(bounds.size)
        return SwipeDirection.allDirections.reduce((distance: CGFloat.infinity, direction: nil), { closest, direction -> (CGFloat, SwipeDirection?) in
            let distance = direction.point.distanceTo(normalizedDragPoint)
            if distance < closest.distance {
                return (distance, direction)
            }
            return closest
        }).direction
    }

    private var dragPercentage: CGFloat {
        guard let dragDirection = dragDirection else { return 0.0 }

        let normalizedDragPoint = swipeableProperties.panGestureTranslation.normalizedDistanceForSize(frame.size)
        let swipePoint = normalizedDragPoint.scalarProjectionPointWith(dragDirection.point)

        let rect = SwipeDirection.boundsRect

        if !rect.contains(swipePoint) {
            return 1.0
        } else {
            let centerDistance = swipePoint.distanceTo(.zero)
            let targetLine = (swipePoint, CGPoint.zero)

            return rect.perimeterLines
                .flatMap { CGPoint.intersectionBetweenLines(targetLine, line2: $0) }
                .map { centerDistance / $0.distanceTo(.zero) }
                .min() ?? 0.0
        }
    }

    private func endedPanAnimation() {
        self.layer.transform = CATransform3DIdentity
        
    }

    private func animationPointForDirection(_ direction: SwipeDirection) -> CGPoint {
        let point = direction.point
        let animatePoint = CGPoint(x: point.x * 4, y: point.y * 4)
        let retPoint = animatePoint.screenPointForSize(UIScreen.main.bounds.size)
        return retPoint
    }

    private func resetCardViewPosition() {
        
        let resetAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.frame))
        resetAnimation.fromValue = NSValue(cgRect: .init(origin: layer.frame.origin, size: layer.frame.size))
        resetAnimation.toValue = NSValue(cgRect: .init(origin: .zero, size: layer.frame.size))
        resetAnimation.duration = 1.0
        resetAnimation.isRemovedOnCompletion = true
        layer.add(resetAnimation, forKey: "resetPosition")
    }
}
