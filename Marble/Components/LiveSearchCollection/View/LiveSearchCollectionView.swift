//
//  CollectionView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public class LiveSearchCollectionView: GraniteView {
    
    lazy var collection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = SearchStyle.itemSpacing
        layout.minimumLineSpacing = SearchStyle.lineSpacing
        layout.estimatedItemSize = SearchStyle.cellSize
        
        let collection: UICollectionView = .init(
            frame: .zero,
            collectionViewLayout: layout)
        
        collection.contentInset = .init(
            top: 0.0,
            left: GlobalStyle.padding,
            bottom: 0.0,
            right: GlobalStyle.padding)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collection)
        
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
}
