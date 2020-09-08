//
//  BrowserView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class BrowserView: GraniteView {
    lazy var browserLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "Your Models".localized.capitalized
        view.font = GlobalStyle.Fonts.courier(.Xlarge, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.sizeToFit()
        return view
    }()
    
    lazy var predictionEngineLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "engine:".localized
        view.font = GlobalStyle.Fonts.courier(.small, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.numberOfLines = 0
        view.textAlignment = .right
        view.isUserInteractionEnabled = false
        view.sizeToFit()
        return view
    }()
    
    lazy var predictionEngineVersion: PaddingLabel = {
        let view: PaddingLabel = .init(
            UIEdgeInsets.init(
                top: 0,
                left: GlobalStyle.spacing,
                bottom: 0.0,
                right: GlobalStyle.spacing))
        view.text = "David".localized.capitalized
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
    
    lazy var stackViewHeader: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                browserLabel,
                predictionEngineLabel,
                predictionEngineVersion
            ]
        )
        
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.padding/2
        
        return view
    }()
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                stackViewHeader,
                collection.view
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.largePadding
        
        return view
    }()
    
    private(set) lazy var collection: (view: UICollectionView,
        layout: UICollectionViewLayout) = {

        let layout: UICollectionViewLayout
        let flowLayout = UICollectionViewFlowLayout()
            
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = GlobalStyle.padding
        flowLayout.scrollDirection = .vertical
        layout = flowLayout

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
            view.backgroundColor = .clear
        view.alwaysBounceVertical = true
        view.isPrefetchingEnabled = false

        view.contentInsetAdjustmentBehavior = .never
        return (view, layout)
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = GlobalStyle.Colors.black
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
                .offset(GlobalStyle.largePadding).priority(999)
            make.right.bottom.equalToSuperview()
                .offset(-GlobalStyle.largePadding).priority(999)
        }
        
        browserLabel.snp.makeConstraints { make in
            make.width.equalTo(browserLabel.frame.size.width)
        }
        
        predictionEngineVersion.snp.makeConstraints { make in
            make.width.equalTo(predictionEngineVersion.frame.size.width + GlobalStyle.spacing*2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
}
