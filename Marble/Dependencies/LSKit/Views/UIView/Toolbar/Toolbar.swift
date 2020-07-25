//
//  Toolbar.swift
//  Wonder
//
//  Created by Ritesh Pakala on 8/15/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

protocol ToolBarDelegate : class {
    func mainTapped()
    func doneTapped()
}
class ToolBar : UIView {
    weak var delegate : ToolBarDelegate?
    
    /**
     
     Components
     **/
    
    var logoLabel : PlayfairLabel!
    var closetTrigger : FiraSansLabel!
    var doneTrigger : FiraSansLabel!
    
    /**
     
     Options
     **/
    
    struct ToolBarOptions {
        var elementPadding : CGFloat = 10.0
    }
    
    var toolBarOptions = ToolBarOptions()
    let title: String
    let accessoryButtonTitle: String
    let isMain: Bool
    init(frame : CGRect = .zero,
         title: String = "",
         accessoryButtonTitle: String = "done",
         isMain: Bool = true) {
        
        self.title = title
        self.isMain = isMain
        self.accessoryButtonTitle = accessoryButtonTitle
        
        super.init(frame: frame)
        
        style()
        setupComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This device does not support NS Coder.")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.addBorder(edge: .bottom, color: LSConst.Colors.aTouchOfBlack, thickness: 4.0)
    }
    
    func style(){
        self.backgroundColor = LSConst.Colors.offWhite
    }
    
    func setupComponents(){
        setupLogo()
        setupTriggers()
    }
    
    func setupLogo(){
        logoLabel = PlayfairLabel(frame: CGRect.zero, text: title)
        logoLabel.changeFontSize(to: 25)
        
        let logoLabelTextAttr = NSMutableAttributedString.init(string: title)
        let logoLabelTextNS = NSString(string: title)
        let theRangeofHyperSand = logoLabelTextNS.range(of: "&")

        logoLabelTextAttr.setAttributes([NSAttributedString.Key.font: UIFont(name: LSConst.Fonts.PlayfairBoldItalic, size: 20) ?? UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: LSConst.Colors.aTouchOfBlack], range: theRangeofHyperSand)
        
        logoLabel.setAttributedString(with: logoLabelTextAttr)
        
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoLabel)
        
        logoLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: toolBarOptions.elementPadding).isActive = true
        logoLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        logoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        logoLabel.widthAnchor.constraint(equalToConstant: logoLabel.fitSize().width).isActive = true
    }
    
    func setupTriggers(){
        closetTrigger = FiraSansLabel(frame: CGRect.zero, text: "settings", isButton: true)
        closetTrigger.changeFont(to: LSConst.Fonts.FiraSansSemiBold)
        let fitSize = closetTrigger.fitSize()
        closetTrigger.translatesAutoresizingMaskIntoConstraints = false
        closetTrigger.isHidden = !isMain
        self.addSubview(closetTrigger)
        
        closetTrigger.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1*toolBarOptions.elementPadding).isActive = true
        closetTrigger.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 3).isActive = true
        closetTrigger.heightAnchor.constraint(equalToConstant: fitSize.height + LSConst.Styles.FiraSansPadding).isActive = true
        closetTrigger.widthAnchor.constraint(equalToConstant: fitSize.width + LSConst.Styles.FiraSansPadding).isActive = true
        
        doneTrigger = FiraSansLabel(frame: CGRect.zero, text: accessoryButtonTitle, isButton: true)
        doneTrigger.changeFont(to: LSConst.Fonts.FiraSansSemiBold)
        let fitSizeDone = doneTrigger.fitSize()
        doneTrigger.translatesAutoresizingMaskIntoConstraints = false
        doneTrigger.isHidden = isMain
        self.addSubview(doneTrigger)
        
        doneTrigger.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -1*toolBarOptions.elementPadding).isActive = true
        doneTrigger.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 3).isActive = true
        doneTrigger.heightAnchor.constraint(equalToConstant: fitSizeDone.height + LSConst.Styles.FiraSansPadding).isActive = true
        doneTrigger.widthAnchor.constraint(equalToConstant: fitSizeDone.width + LSConst.Styles.FiraSansPadding).isActive = true
        
        let tapOutfits = UITapGestureRecognizer(target: self, action: #selector(self.closetTriggerTapped(_:)))
        tapOutfits.numberOfTapsRequired = 1
        closetTrigger.addGestureRecognizer(tapOutfits)
        
        let tapDone = UITapGestureRecognizer(target: self, action: #selector(self.doneTriggerTapped(_:)))
        tapDone.numberOfTapsRequired = 1
        doneTrigger.addGestureRecognizer(tapDone)
        
    }
}

extension ToolBar {
    @objc func closetTriggerTapped(_ sender : UITapGestureRecognizer) {
        if let delegateCheck = self.delegate{
            delegateCheck.mainTapped()
        }
    }
    
    @objc func doneTriggerTapped(_ sender : UITapGestureRecognizer) {
        
        if let delegateCheck = self.delegate{
            delegateCheck.doneTapped()
        }
    }
}

extension ToolBar {
    func hideMainTrigger(){
        closetTrigger.isHidden = true
    }
    
    func showMainTrigger(){
        closetTrigger.isHidden = false
    }
    
    func hideDoneTrigger(){
        doneTrigger.isHidden = true
    }
    
    func showDoneTrigger(){
        doneTrigger.isHidden = false
    }
}
