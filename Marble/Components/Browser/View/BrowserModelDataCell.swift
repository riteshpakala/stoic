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
    
    lazy var sentimentLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .right
        label.textColor = GlobalStyle.Colors.black
        return label
    }()
    
    lazy var daysLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .right
        label.textColor = GlobalStyle.Colors.black
        return label
    }()
    
    lazy var selectionButton: UIButton = {
        let button: UIButton = .init()
        button.backgroundColor = .clear
        button.layer.cornerRadius = BrowserStyle.dataModelSelectionSize.width/2
        button.layer.borderColor = GlobalStyle.Colors.black.cgColor
        button.layer.borderWidth = 2.0
        return button
    }()
    
    lazy var actionsContainerView: UIView = {
        let view: UIView = .init()
        
        return view
    }()
    
    var model: StockModel? = nil {
        didSet {
            sentimentLabel.text = model?.sentiment.asString
            daysLabel.text = "\("days trained".localized.lowercased()): "+String(model?.days ?? 0)
        }
    }
    
    lazy var stackInfoView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                daysLabel,
                sentimentLabel
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = GlobalStyle.spacing
        
        return view
    }()
    
    lazy var stackActionView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                actionsContainerView
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
        
        contentView.layer.borderColor = GlobalStyle.Colors.marbleBrown.cgColor
        contentView.layer.borderWidth = 2.0
        contentView.layer.cornerRadius = 4.0
        contentView.backgroundColor = GlobalStyle.Colors.marbleBrown
        
        contentView.addSubview(stackActionView)
        stackActionView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(GlobalStyle.padding)
            make.bottom.equalToSuperview().offset(-GlobalStyle.padding)
            make.width.equalToSuperview().multipliedBy(0.36)
        }
        
        contentView.addSubview(stackInfoView)
        stackInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(GlobalStyle.padding)
            make.bottom.right.equalToSuperview().offset(-GlobalStyle.padding)
            make.left.equalTo(stackActionView.snp.right)
        }
        
        actionsContainerView.addSubview(selectionButton)
        selectionButton.snp.makeConstraints { make in
            make.size.equalTo(BrowserStyle.dataModelSelectionSize)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
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
        
        sentimentLabel.text = ""
        daysLabel.text = ""
    }
}
