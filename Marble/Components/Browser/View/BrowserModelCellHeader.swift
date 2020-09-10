//
//  BrowserModelCellHeader.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/9/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import Granite
import UIKit

class BrowserModelCellHeader: UICollectionReusableView {
    
    lazy var dateLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textColor = GlobalStyle.Colors.orange
        label.textAlignment = .left
        return label
    }()
    
    lazy var modelsWithinLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textColor = GlobalStyle.Colors.orange
        label.textAlignment = .right
        return label
    }()
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                dateLabel,
                modelsWithinLabel
            ]
        )
        
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.spacing
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
