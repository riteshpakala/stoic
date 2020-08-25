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
import StoreKit

class SubscriptionOption: GraniteView {
    lazy var priceLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "$11.99/mo"
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.large, .bold)
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
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
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
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapGestureTapped(_:)))
    }()
    
    let product: SKProduct
    init(product: SKProduct) {
        self.product = product
        super.init(frame: .zero)
        
        priceLabel.text = "\(product.priceLocale.currencySymbol ?? "$")\(product.price)/\(product.subscriptionPeriod?.unit.description() ?? "month")"
        
        if let discount = product.discounts.first {
            trialLabel.text = "Free trial: \(discount.subscriptionPeriod.unit.description(numberOfUnits: discount.subscriptionPeriod.numberOfUnits))"
        } else {
            trialLabel.isHidden = true
        }
//        if let intro = product.introductoryPrice {
//            trialLabel.text = "\(intro.subscriptionPeriod.unit.description())"
//        } else {
//            trialLabel.isHidden = true
//        }
        print("{TEST} \(product.productIdentifier)")
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.bottom.equalToSuperview().offset(-GlobalStyle.padding)
        }
        
        addGestureRecognizer(tapGesture)
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
    
    @objc func tapGestureTapped(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        bubbleEvent(SubscribeEvents.SelectedProduct(product: product))
    }
}

extension SKProduct.PeriodUnit {
    func description(capitalizeFirstLetter: Bool = false, numberOfUnits: Int? = nil) -> String {
        let period:String = {
            switch self {
            case .day: return "day"
            case .week: return "week"
            case .month: return "month"
            case .year: return "year"
            }
        }()

        var numUnits = ""
        var plural = ""
        if let numberOfUnits = numberOfUnits {
            numUnits = "\(numberOfUnits) " // Add space for formatting
            plural = numberOfUnits > 1 ? "s" : ""
        }
        return "\(numUnits)\(capitalizeFirstLetter ? period.capitalized : period)\(plural)"
    }
}
