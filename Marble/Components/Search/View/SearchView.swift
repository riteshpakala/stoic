//
//  SearchView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

public class SearchView: GraniteView {
    lazy var searchBoxContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var searchBoxTextField: UITextField = {
        let textField = UITextField()
        textField.font = GlobalStyle.Fonts.courier(.large, .bold)
        textField.textColor = GlobalStyle.Colors.purple
        textField.backgroundColor = .clear
        textField.placeholder = "Search".localized
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var collection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = LiveSearchCollectionStyle.itemSpacing
        layout.minimumLineSpacing = LiveSearchCollectionStyle.lineSpacing
        layout.estimatedItemSize = LiveSearchCollectionStyle.cellSize
        
        let collection: UICollectionView = .init(
            frame: .zero,
            collectionViewLayout: layout)
        
        collection.contentInset = .init(
            top: GlobalStyle.padding,
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
        
        backgroundColor = .clear
        addSubview(searchBoxContainerView)
        searchBoxContainerView.addSubview(searchBoxTextField)
        
        searchBoxContainerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(SearchStyle.searchSizeInActive.height)
        }
        
        searchBoxTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
        }
        
        addSubview(collection)
        collection.snp.makeConstraints { make in
            make.top.equalTo(searchBoxContainerView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0.0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    override public func hitTest(
        _ point: CGPoint,
        with event: UIEvent?) -> UIView? {
        
        if let view = super.hitTest(point, with: event), view == self {
            if searchBoxTextField.isFirstResponder {
                searchBoxTextField.resignFirstResponder()
            }
        }
        
        return super.hitTest(point, with: event)
    }
}
