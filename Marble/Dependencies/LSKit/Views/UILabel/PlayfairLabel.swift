//
//  PlayFairLabel.swift
//  LinenAndSole
//
//  Created by Ritesh Pakala on 4/18/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

class PlayfairLabel : UILabel {
    var borderLayer : CALayer = CALayer()
    
    init(frame: CGRect, text: String, fontSize : CGFloat = 20, isButton : Bool = false) {
        super.init(frame: frame)
        
        self.font = UIFont(name: LSConst.Fonts.PlayfairBlack, size: fontSize)
        self.text = text
        self.textColor = LSConst.Colors.aTouchOfBlack
        
        if isButton {
            self.isUserInteractionEnabled = true
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Device does not support NS Coder.")
    }
    
    func setAttributedString(with : NSAttributedString){
        self.attributedText = with
    }
    
    func changeFont(to : String) {
        self.font = UIFont(name: to, size: self.font.pointSize)
    }
    
    func changeFontColor(to: UIColor){
        self.textColor = to
    }
    
    func changeFontSize(to : CGFloat) {
        self.font = UIFont(name: self.font.fontName, size: to)
    }
    
    func fitSize() -> CGSize{
        self.sizeToFit()
        
        return self.frame.size
    }
    
    func updateBorder(_ size : CGSize){
        borderLayer.removeFromSuperlayer()
        borderLayer = CALayer()
        borderLayer.frame = CGRect(origin: CGPoint(x: LSConst.Styles.PlayFairPadding.x, y: LSConst.Styles.PlayFairPadding.y), size: self.bounds.size)
        
        borderLayer.addBorder(edge: .bottom, color: LSConst.Colors.aTouchOfBlack, thickness: 3.0, growBottomBy: abs(LSConst.Styles.PlayFairPadding.x/1.5))
        borderLayer.addBorder(edge: .left, color: LSConst.Colors.aTouchOfBlack, thickness: 3.0)
        
        self.layer.addSublayer(borderLayer)
    }
    
    func addPadding(of size: CGFloat, to edge: UIRectEdge) {
        switch edge {
        case .top:
            self.topInset = size
        case .bottom:
            self.bottomInset = size
        case .left:
            self.leftInset = size
        case .right:
            self.rightInset = size
        default:
            break
        }
        
        self.invalidateIntrinsicContentSize()
    }
    
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
}
