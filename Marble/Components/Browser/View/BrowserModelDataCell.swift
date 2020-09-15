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
        case mergedModel
        case inCompatible
        case compatible
        case none
    }
    
    lazy var idLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .right
        label.textColor = GlobalStyle.Colors.black
        return label
    }()
    
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
    
    lazy var loadButton: PaddingLabel = {
        let view: PaddingLabel = .init(
            UIEdgeInsets.init(
                top: 0,
                left: GlobalStyle.spacing*2,
                bottom: 0.0,
                right: GlobalStyle.spacing*2))
        view.text = "load".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.layer.borderColor = GlobalStyle.Colors.orange.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 4.0
        view.textAlignment = .center
        view.isUserInteractionEnabled = false
        view.sizeToFit()
        return view
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
            sentimentLabel.text = "\("sentiment".localized.lowercased()): "+(model?.sentiment?.asString ?? "")
            daysLabel.text = "\("days trained".localized.lowercased()): "+String(model?.days ?? 0)
            idLabel.text = "\((model?.id.components(separatedBy: "-").last ?? "").lowercased())"
        }
    }
    
    lazy var stackInfoView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                daysLabel,
                sentimentLabel,
                idLabel
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
            case .baseModel, .mergedModel:
                baseModelSelected = true
                modelIsAvailableForSelection = false
                modelSelected = true
                selectionButton.isHidden = false
                notCompatibleLabel.isHidden = true
                loadButton.isHidden = true
                self.selectionButton.layer.backgroundColor = GlobalStyle.Colors.black.cgColor
                contentView.layer.opacity = 1.0
                contentView.backgroundColor = GlobalStyle.Colors.orange
            case .appendedModel:
                baseModelSelected = false
                modelIsAvailableForSelection = true
                modelSelected = true
                selectionButton.isHidden = false
                notCompatibleLabel.isHidden = true
                loadButton.isHidden = true
                self.selectionButton.layer.backgroundColor = GlobalStyle.Colors.black.cgColor
                contentView.layer.opacity = 1.0
                contentView.backgroundColor = GlobalStyle.Colors.purple
            case .compatible:
                baseModelSelected = false
                modelIsAvailableForSelection = true
                modelSelected = false
                self.selectionButton.isHidden = false
                self.notCompatibleLabel.isHidden = true
                self.loadButton.isHidden = true
                self.selectionButton.layer.backgroundColor = UIColor.clear.cgColor
                contentView.layer.opacity = 1.0
                contentView.backgroundColor = GlobalStyle.Colors.marbleBrown
            case .inCompatible:
                baseModelSelected = false
                modelIsAvailableForSelection = false
                modelSelected = false
                self.selectionButton.isHidden = true
                self.notCompatibleLabel.isHidden = false
                self.loadButton.isHidden = true
                self.selectionButton.layer.backgroundColor = UIColor.clear.cgColor
                contentView.layer.opacity = 0.5
                contentView.backgroundColor = GlobalStyle.Colors.marbleBrown
            default:
                selectionButton.isHidden = true
                notCompatibleLabel.isHidden = true
                self.loadButton.isHidden = false
                self.selectionButton.layer.backgroundColor = UIColor.clear.cgColor
                contentView.backgroundColor = GlobalStyle.Colors.marbleBrown
                contentView.layer.opacity = 1.0
            }
            
            longPressGesture.isEnabled = status == BrowserModelStatus.none
        }
    }
    
    var currentCreationStatusStep: BrowserCompiledModelCreationStatus = .none
    
    var baseModelSelected: Bool = false
    
    var modelSelected: Bool = false
    
    var modelIsAvailableForSelection: Bool = true
    
    private var longPressGesture: UILongPressGestureRecognizer {
        let gesture:UILongPressGestureRecognizer = .init(target: self, action: #selector(self.cellWasLongPressed(_:)))
        gesture.cancelsTouchesInView = true
        return gesture
    }
    
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
            make.width.equalToSuperview().multipliedBy(0.24)
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
        
        actionsContainerView.addSubview(loadButton)
        loadButton.snp.makeConstraints { make in
            make.height.equalTo(loadButton.font.lineHeight+(GlobalStyle.spacing*2))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(loadButton.frame.size.width+(GlobalStyle.spacing*4))
        }
        
        actionsContainerView.addSubview(notCompatibleLabel)
        notCompatibleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addGestureRecognizer(longPressGesture)
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
    
    @objc
    func cellWasLongPressed(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began, status == BrowserModelStatus.none else { return }
        
        let controller = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let remove: UIAlertAction = .init(title: "remove", style: .destructive, handler: { [weak self] alert in
            
            DispatchQueue.main.async {
                self?.undim()
            }
            self?.bubble(BrowserEvents.RemoveModel.init(self?.model?.id ?? ""))
        })
        
        let cancel: UIAlertAction = .init(title: "cancel", style: .cancel, handler: { [weak self] alert in
            DispatchQueue.main.async {
                self?.undim()
            }
        })
        
        controller.addAction(remove)
        controller.addAction(cancel)
        
        self.dim()
        
        bubble(HomeEvents.PresentAlertController.init(controller))
    }
}
