//
//  SearchCell.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

class SearchCollectionCell: UICollectionViewCell {
    lazy var tickerLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "$TSLA"
        label.textColor = GlobalStyle.Colors.green
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tickerLabel)
        
        self.backgroundColor = .clear
        
        tickerLabel.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
