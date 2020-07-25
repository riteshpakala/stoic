//
//  UITextField.swift
//  LinenAndSole
//
//  Created by Ritesh Pakala on 4/19/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

class StandardPlayfairField : UITextField {
    
    var borderColor = LSConst.Colors.offBlack
    var borderLayer = CALayer()
    var originalSize = CGSize.zero
    var showBorder: Bool = true
    
    init(frame : CGRect, placeholder : String = "", placeholderColor : UIColor = LSConst.Colors.offBlack, size: CGFloat = 20, showBorder: Bool = true) {
        self.showBorder = showBorder
        super.init(frame: frame)
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor: placeholderColor.withAlphaComponent(0.75)])
        self.originalSize = frame.size
        self.font = UIFont(name: LSConst.Fonts.PlayfairBoldItalic, size: size)
        self.textColor = LSConst.Colors.offBlack
        self.autocorrectionType = .no
//        setupTextChangeNotification()
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This device does not support NSCoding")
    }
    
    func changeFont(to : String) {
        guard self.font != nil else { return }
        self.font = UIFont(name: to, size: self.font!.pointSize)
    }
    
    func changeFontSize(to : CGFloat) {
        guard self.font != nil else { return }
        self.font = UIFont(name: self.font!.fontName, size: to)
    }
    
    func changeFontColor(to : UIColor) {
        self.textColor = to
        borderColor = to
    }
    
    let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func updateBorder(){
        guard showBorder else { return }
        borderLayer.removeFromSuperlayer()
        borderLayer = CALayer()
        borderLayer.frame = self.frame
        borderLayer.frame.origin = CGPoint(x: LSConst.Styles.PlayFairPadding.x, y: LSConst.Styles.PlayFairPadding.y)
        
        borderLayer.addBorder(edge: .bottom, color: LSConst.Colors.offBlack, thickness: 3.0, growBottomBy: abs(LSConst.Styles.PlayFairPadding.x/1.5))
        borderLayer.addBorder(edge: .left, color: LSConst.Colors.offBlack, thickness: 3.0)
        
        self.layer.addSublayer(borderLayer)
    }
    
//    func setupTextChangeNotification() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.textDidChange(notification:)),
//            name: UITextField.textDidChangeNotification,
//            object: nil)
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
//    @objc func textDidChange(notification : NSNotification) {
//        fitToSize()
//    }
//
//    func fitToSize(){
//        self.sizeToFit()
//
//        var adjSize = originalSize
//
//        if self.frame.size.width > originalSize.width {
//            adjSize.width = self.frame.size.width
//        }
//        self.frame.size = adjSize
//
//        updateBorder()
//    }
}

