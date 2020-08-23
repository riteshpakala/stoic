//
//  SubscribeCell.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

class SubscriptionOption: UIView {
    lazy var priceLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "$11.99/mo"
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var trialLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "3 day free trial".localized
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let view: UIStackView = UIStackView.init(
            arrangedSubviews: [
                .init(),
                priceLabel,
                trialLabel,
                .init()
            ]
        )
        
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillEqually
        view.spacing = GlobalStyle.padding
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.bottom.equalToSuperview().offset(-GlobalStyle.padding)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderColor = GlobalStyle.Colors.orange.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 4.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
