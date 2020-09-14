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
    
    var isAvailable: Bool = false {
        didSet {
            if isAvailable {
                tickerLabel.textColor = GlobalStyle.Colors.green
            } else {
                tickerLabel.textColor = GlobalStyle.Colors.red
            }
        }
    }
    
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
        
        isAvailable = false
    }
}

class SearchCollectionHeaderCell: UICollectionReusableView {
    lazy var label: UILabel = {
        let label: UILabel = .init()
        label.text = "FREE".localized.uppercased()
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .center
        return label
    }()
    
    var isPRO: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    var isOffline: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        
        self.backgroundColor = .clear
        
        label.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isPRO = false
        isOffline = false
    }
    
    func updateAppearance() {
        guard !isOffline else {
            label.text = "OFFLINE".localized.uppercased()
            label.textColor = GlobalStyle.Colors.red
            return
        }
        
        if isPRO {
            label.text = "LIVE".localized.uppercased()
            label.textColor = GlobalStyle.Colors.purple
        } else {
            label.text = "FREE".localized.uppercased()
            label.textColor = GlobalStyle.Colors.orange
        }
    }
}
