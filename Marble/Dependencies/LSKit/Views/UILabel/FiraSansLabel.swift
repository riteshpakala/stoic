//
//  File.swift
//  LinenAndSole
//
//  Created by Ritesh Pakala on 4/18/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

class FiraSansLabel : UILabel {
    
    var borderColor : UIColor = LSConst.Colors.aSpaceGray
    
    struct FiraSansOptions {
        var isButton = false
    }
    
    var firaSansOptions = FiraSansOptions()
    
    init(frame: CGRect, text: String, fontSize: CGFloat = 20, isButton : Bool = false) {
        super.init(frame: frame)
        
        self.font = UIFont(name: LSConst.Fonts.FiraSansRegular, size: fontSize)
        self.text = text
        self.textColor = LSConst.Colors.aDarkSpaceGray
        self.firaSansOptions.isButton = isButton
        
        if isButton {
            self.isUserInteractionEnabled = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This device does not support NSCoding.")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setBorder()
    }
    
    func changeFont(to : String) {
        self.font = UIFont(name: to, size: self.font.pointSize)
    }
    
    func changeFontColor(to : UIColor) {
        self.textColor = to
        self.borderColor = to
        
        if let sublayers = self.layer.sublayers {
            sublayers[sublayers.count - 1].removeFromSuperlayer()
            sublayers[sublayers.count - 2].removeFromSuperlayer()
        }
    }
    
    func changeFontSize(to : CGFloat) {
        self.font = UIFont(name: self.font.fontName, size: to)
    }
    
    func fitSize() -> CGSize{
        self.sizeToFit()
        
        return self.frame.size
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

extension FiraSansLabel {
    func setBorder(){
        if firaSansOptions.isButton {
            self.layer.addBorder(edge: .right, color: borderColor, thickness: 3.0, shrinkRightBy: 8.0)
            self.layer.addBorder(edge: .top, color: borderColor, thickness: 3.0)
        }
    }
    
}
