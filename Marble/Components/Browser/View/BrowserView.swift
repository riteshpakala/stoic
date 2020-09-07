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
        view.text = "Model Browser".localized.capitalized
        view.font = GlobalStyle.Fonts.courier(.Xlarge, .bold)
        view.textColor = GlobalStyle.Colors.green
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                browserLabel,
                .init()
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
//        flowLayout.itemSize = CGSize(width: 200.0, height: 144.0)
//        flowLayout.sectionInset = UIEdgeInsets(
//            top: SharedStyle.padding,
//            left: SharedStyle.padding,
//            bottom: SharedStyle.padding,
//            right: SharedStyle.padding)

        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0

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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
}
