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
        label.text = "$11.99"
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .center
        
        label.numberOfLines = 0
        return label
    }()
    
    lazy var trialLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "3 day trial".localized
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                topSpacer,
                priceLabel,
                trialLabel,
                bottomSpacer
            ]
        )
        
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = GlobalStyle.padding
        
        return view
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapGestureTapped(_:)))
    }()
    
    lazy var topSpacer: UIView = {
        return .init()
    }()
    
    lazy var bottomSpacer: UIView = {
        return .init()
    }()
    
    let product: SKProduct
    init(product: SKProduct) {
        self.product = product
        super.init(frame: .zero)
        
        priceLabel.text = "\(product.priceLocale.currencySymbol ?? "$")\(product.price)\n/\(product.subscriptionPeriod?.unit.description(numberOfUnits: product.subscriptionPeriod?.numberOfUnits) ?? "month")"
        
        if let discount = product.discounts.first {
            trialLabel.text = "\(discount.subscriptionPeriod.unit.description(numberOfUnits: discount.subscriptionPeriod.numberOfUnits, showNumber: true))\ntrial"
        } else {
            trialLabel.isHidden = true
            topSpacer.isHidden = true
            bottomSpacer.isHidden = true
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
    func description(
        capitalizeFirstLetter: Bool = false,
        numberOfUnits: Int? = nil,
        showNumber: Bool = false) -> String {
        
        
        let period:String = {
            switch self {
            case .day:
                if numberOfUnits == 7 {
                    return "week"
                } else {
                    return "day"
                }
            case .week: return "week"
            case .month: return "month"
            case .year: return "year"
            @unknown default:
                return "unknown"
            }
        }()

        var numUnits = ""
        if let numberOfUnits = numberOfUnits, showNumber {
            numUnits = "\(numberOfUnits) " // Add space for formatting
        }
        return "\(numUnits)\(capitalizeFirstLetter ? period.capitalized : period)"
    }
}
