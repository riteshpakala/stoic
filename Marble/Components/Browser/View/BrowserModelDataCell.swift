//
//  BrowserModelDataCell.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/7/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import Granite
import Foundation
import UIKit

public class BrowserModelDataCell: UICollectionViewCell {
    
    lazy var tradingDayLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .right
        label.textColor = GlobalStyle.Colors.orange
        return label
    }()
    
    lazy var sentimentLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .right
        label.textColor = GlobalStyle.Colors.orange
        return label
    }()
    
    lazy var daysLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .right
        label.textColor = GlobalStyle.Colors.orange
        return label
    }()
    
    lazy var modelsWithinLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .left
        label.textColor = GlobalStyle.Colors.orange
        return label
    }()
    
    var model: StockModel? = nil {
        didSet {
            tradingDayLabel.text = model?.tradingDay
            sentimentLabel.text = model?.sentiment.asString
            daysLabel.text = "\("days trained".localized.lowercased()): "+String(model?.days ?? 0)
            modelsWithinLabel.text = "\("models within".localized.lowercased()): 1"
        }
    }
    
    lazy var stackInfoView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                tradingDayLabel,
                sentimentLabel,
                daysLabel
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.spacing
        
        return view
    }()
    
    lazy var stackActionView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                modelsWithinLabel
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.spacing
        
        return view
    }()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.borderColor = GlobalStyle.Colors.orange.cgColor
        contentView.layer.borderWidth = 2.0
        contentView.layer.cornerRadius = 4.0
        
        contentView.addSubview(stackActionView)
        stackActionView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(GlobalStyle.padding)
            make.bottom.equalToSuperview().offset(-GlobalStyle.padding)
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        
        contentView.addSubview(stackInfoView)
        stackInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(GlobalStyle.padding)
            make.bottom.right.equalToSuperview().offset(-GlobalStyle.padding)
            make.left.equalTo(stackActionView.snp.right)
        }
    }
    
    override public func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        tradingDayLabel.text = ""
        sentimentLabel.text = ""
    }
}

extension BrowserModelDataCell {
    
}
