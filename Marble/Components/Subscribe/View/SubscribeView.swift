//
//  SubscribeView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class SubscribeView: GraniteView {
    
    lazy var subscribeLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "* subscription".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.Xlarge, .bold)
        view.textColor = GlobalStyle.Colors.purple
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var subscribeSubLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "// benefits".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.large, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var subscriptionDescription: UILabel = {
        let view: UILabel = .init()
        view.text =
            """
            /**** loading... */
            """
        
        if LSConst.Device.isIPhone6Plus {

            view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        } else {

            view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        }
        view.textColor = GlobalStyle.Colors.orange
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.numberOfLines = 0
        return view
    }()
    
    lazy var contact: ContactView = {
        let view: ContactView = .init()
        return view
    }()
    
    lazy var eula: EULAView = {
        let view: EULAView = .init()
        return view
    }()
    
    lazy var stackViewSubscriptionOptions: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init()
        
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = GlobalStyle.padding
        view.isHidden = true
        return view
    }()
    
    lazy var optionsLoadingLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.text = "/**** loading... */"
        return label
    }()
    
    lazy var loaderView: (container: UIView, label: UILabel) = {
        let view: UIView = .init()
        view.backgroundColor = GlobalStyle.Colors.green.withAlphaComponent(0.36)
        
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.green
        label.text = "/**** processing... */"
        label.sizeToFit()
        label.backgroundColor = GlobalStyle.Colors.black
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(label.font.lineHeight + 8)
            loaderLabelWidthConstraint = make.width.equalTo(label.frame.size.width + GlobalStyle.padding).constraint
            make.center.equalToSuperview()
        }
        view.isHidden = true
        
        return (view, label)
    }()
    
    lazy var theImage: UIImageView = {
        let view: UIImageView = .init()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.image = UIImage.init(named: "subscription.preview")
        return view
    }()
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                subscribeLabel,
                subscribeSubLabel,
                subscriptionDescription,
                theImage,
                spacer,
                stackViewSubscriptionOptions,
                optionsLoadingLabel,
                spacer2,
                contact,
                eula
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = LSConst.Device.isIPhone6 ? GlobalStyle.spacing*2 : (LSConst.Device.isIPhone6Plus ? GlobalStyle.padding : GlobalStyle.largePadding)
        view.setCustomSpacing(0, after: theImage)
        view.setCustomSpacing(LSConst.Device.isIPhoneX ? GlobalStyle.spacing : view.spacing, after: spacer2)
        view.setCustomSpacing(GlobalStyle.spacing*2, after: contact)
        
        return view
    }()
    
    lazy var spacer: UIView = {
        return .init()
    }()
    
    lazy var spacer2: UIView = {
        return .init()
    }()
    
    lazy var spacer3: UIView = {
        return .init()
    }()
    
    private var loaderLabelWidthConstraint: Constraint?
    private var loader: ConsoleLoader?
    override public init(frame: CGRect) {
        super.init(frame: frame)
        loader = .init(self, baseText: "/**** loading\(ConsoleLoader.seperator) */")
        backgroundColor = GlobalStyle.Colors.black
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(GlobalStyle.largePadding).priority(999)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
                .offset(GlobalStyle.largePadding).priority(999)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
                .offset(-GlobalStyle.largePadding).priority(999)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-GlobalStyle.largePadding).priority(999)
        }
        
        optionsLoadingLabel.snp.makeConstraints { make in
            make.height.equalTo(SubscribeStyle.optionSize.height)
        }
        
        theImage.snp.makeConstraints { make in
            make.height.equalTo(SubscribeStyle.imageSize.height)
        }
        
        addSubview(loaderView.container)
        loaderView.container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subscriptionDescription.text = ServiceCenter.SubscriptionBenefits.allCases.filter({
            $0.isActive })
            .map({ "- "+$0.rawValue })
            .joined(separator: "\n")
        
        beginLoader(forOptions: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLoaderAppearance(confirming: Bool) {
        if confirming {
            loaderView.label.textColor = GlobalStyle.Colors.purple
            loaderView.label.text = "/**** confirming... */"
            loaderView.container.backgroundColor = GlobalStyle.Colors.purple.withAlphaComponent(0.36)
            
            let isLoading = self.loader?.isLoading == true
            self.loader?.stop()
            self.loader = .init(self, baseText: "/**** confirming\(ConsoleLoader.seperator) */")
            loaderView.label.text = self.loader?.defaultStatus
            guard isLoading else { return }
            self.loader?.begin()
        } else {
            loaderView.label.textColor = GlobalStyle.Colors.green
            loaderView.label.text = "/**** processing... */"
            loaderView.container.backgroundColor = GlobalStyle.Colors.green.withAlphaComponent(0.36)
            
            let isLoading = self.loader?.isLoading == true
            self.loader?.stop()
            self.loader = .init(self, baseText: "/**** processing\(ConsoleLoader.seperator) */")
            loaderView.label.text = self.loader?.defaultStatus
            guard isLoading else { return }
            self.loader?.begin()
        }
        
        loaderView.label.sizeToFit()
        loaderLabelWidthConstraint?.update(offset: loaderView.label.frame.size.width + GlobalStyle.padding)
    }
    
    func updateAppearance(landscape: Bool) {
        if landscape {
            theImage.isHidden = true
            stackViewSubscriptionOptions.isHidden = true
            spacer2.isHidden = true
        } else {
            theImage.isHidden = false
            stackViewSubscriptionOptions.isHidden = false
            spacer2.isHidden = false
        }
        
        stackView.setNeedsDisplay()
    }
}

extension SubscribeView: ConsoleLoaderDelegate {
    public func consoleLoaderUpdated(_ indicator: String) {
        loaderView.label.text = indicator
        optionsLoadingLabel.text = indicator
        
        loaderView.label.sizeToFit()
        loaderLabelWidthConstraint?.update(offset: loaderView.label.frame.size.width + GlobalStyle.padding)
    }
    
    public func beginLoader(forOptions: Bool = false) {
        loaderView.container.isHidden = forOptions
        loader?.begin()
    }
    
    public func stopLoader() {
        loaderView.container.isHidden = true
        loader?.stop()
    }
}
