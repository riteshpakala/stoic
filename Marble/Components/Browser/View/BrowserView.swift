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
        view.text = "* models".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.Xlarge, .bold)
        view.textColor = GlobalStyle.Colors.purple
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
                left: GlobalStyle.spacing*2,
                bottom: 0.0,
                right: GlobalStyle.spacing*2))
        view.text = "david".localized.lowercased()
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
    
    lazy var subHeaderContainer: UIView = {
            let view: UIView = .init()
            view.backgroundColor = .clear
            return view
    }()
    
    lazy var nextTradingDayLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .left
        label.textColor = GlobalStyle.Colors.green
        label.text = "/**** loading... */"
        return label
    }()
    
    lazy var emptyLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.text = "You don't have any models, search for a stock to train a model & it will appear here. Train more than 1 to combine them into a more refined version over time".localized.lowercased()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var stackViewHeader: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                browserLabel,
//                predictionEngineLabel,
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
                subHeaderContainer,
                collection.view
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.largePadding
        
        return view
    }()
    
    private(set) lazy var collection: (
        view: UICollectionView,
        layout: UICollectionViewLayout) = {

        let layout: UICollectionViewLayout
        let flowLayout = UICollectionViewFlowLayout()
            
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = GlobalStyle.largePadding
        flowLayout.scrollDirection = .horizontal
        layout = flowLayout

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
            view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.isPrefetchingEnabled = false
        view.isPagingEnabled = false
        view.decelerationRate = UIScrollView.DecelerationRate.fast
        view.contentInsetAdjustmentBehavior = .never
            
        return (view, layout)
    }()
    
    private var loader: ConsoleLoader?
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        loader = .init(self, baseText: "/**** loading\(ConsoleLoader.seperator) */")
        self.backgroundColor = GlobalStyle.Colors.black
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(GlobalStyle.largePadding).priority(999)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
                .offset(GlobalStyle.largePadding).priority(999)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
                .offset(-GlobalStyle.largePadding).priority(999)
            make.bottom.equalToSuperview().priority(999)
        }
        
        subHeaderContainer.snp.makeConstraints { make in
            make.height.equalTo(nextTradingDayLabel.font.lineHeight)
            
        }
        subHeaderContainer.addSubview(nextTradingDayLabel)
        nextTradingDayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        predictionEngineVersion.snp.makeConstraints { make in
            make.width.equalTo(predictionEngineVersion.frame.size.width + GlobalStyle.spacing*4)
        }
        
        loader?.begin()
        self.dim()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    func setupEmptyView() {
        self.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
                
            make.left.equalToSuperview()
                .offset(GlobalStyle.largePadding)
            make.right.equalToSuperview()
                .offset(-GlobalStyle.largePadding)
        }
    }
}

extension BrowserView: ConsoleLoaderDelegate {
    public func consoleLoaderUpdated(_ indicator: String) {
        self.nextTradingDayLabel.text = indicator
    }
    
    public func updateTradingLabel(_ text: String) {
        loader?.stop()
        self.nextTradingDayLabel.text = text
    }
}
