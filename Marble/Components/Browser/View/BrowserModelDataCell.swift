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
    public enum BrowserModelStatus {
        case baseModel
        case appendedModel
        case inCompatible
        case compatible
        case none
    }
    
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
    
    lazy var selectionButton: UIView = {
        let button: UIView = .init()
        button.backgroundColor = .clear
        button.layer.cornerRadius = BrowserStyle.dataModelSelectionSize.width/2
        button.layer.borderColor = GlobalStyle.Colors.black.cgColor
        button.layer.borderWidth = 2.0
        button.isHidden = true
        return button
    }()
    
    lazy var notCompatibleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .left
        label.text = "not compatible".localized.lowercased()
        label.textColor = GlobalStyle.Colors.black
        label.isHidden = true
        label.numberOfLines = 0
        return label
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
    
    var status: BrowserModelStatus? = nil {
        didSet {
            guard status != oldValue else { return }
            switch status {
            case .baseModel:
                baseModelSelected = true
                modelIsAvailableForSelection = false
                modelSelected = true
                selectionButton.isHidden = false
                notCompatibleLabel.isHidden = true
                self.selectionButton.layer.backgroundColor = GlobalStyle.Colors.black.cgColor
                contentView.layer.opacity = 1.0
                contentView.backgroundColor = GlobalStyle.Colors.orange
            case .appendedModel:
                baseModelSelected = false
                modelIsAvailableForSelection = true
                modelSelected = true
                selectionButton.isHidden = false
                notCompatibleLabel.isHidden = true
                self.selectionButton.layer.backgroundColor = GlobalStyle.Colors.black.cgColor
                contentView.layer.opacity = 1.0
                contentView.backgroundColor = GlobalStyle.Colors.purple
            case .compatible:
                baseModelSelected = false
                modelIsAvailableForSelection = true
                modelSelected = false
                self.selectionButton.isHidden = false
                self.notCompatibleLabel.isHidden = true
                self.selectionButton.layer.backgroundColor = UIColor.clear.cgColor
                contentView.layer.opacity = 1.0
                contentView.backgroundColor = GlobalStyle.Colors.marbleBrown
            case .inCompatible:
                baseModelSelected = false
                modelIsAvailableForSelection = false
                modelSelected = false
                self.selectionButton.isHidden = true
                self.notCompatibleLabel.isHidden = false
                self.selectionButton.layer.backgroundColor = UIColor.clear.cgColor
                contentView.layer.opacity = 0.5
                contentView.backgroundColor = GlobalStyle.Colors.marbleBrown
            default:
                selectionButton.isHidden = true
                notCompatibleLabel.isHidden = true
                self.selectionButton.layer.backgroundColor = UIColor.clear.cgColor
                contentView.backgroundColor = GlobalStyle.Colors.marbleBrown
                contentView.layer.opacity = 1.0
            }
        }
    }
    
    var currentCreationStatusStep: BrowserCompiledModelCreationStatus = .none
    
    var baseModelSelected: Bool = false
    
    var modelSelected: Bool = false
    
    var modelIsAvailableForSelection: Bool = true
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.borderColor = UIColor.clear.cgColor
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
        
        actionsContainerView.addSubview(notCompatibleLabel)
        notCompatibleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
