//
//  BrowserModelCell.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class BrowserModelCell: UICollectionViewCell {
    
    lazy var valueContainer: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .clear
//        view.layer.borderWidth = 2.0
//        view.layer.borderColor = GlobalStyle.Colors.graniteGray.cgColor
        return view
    }()
    
    lazy var valueLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.green
        return label
    }()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(valueContainer)
        valueContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(GlobalStyle.padding+GlobalStyle.spacing)
            make.height.equalTo(valueContainer.snp.width)
        }
        valueContainer.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(4)
            make.height.equalTo(valueContainer.snp.width)
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
        
        valueLabel.text = ""
    }
}
