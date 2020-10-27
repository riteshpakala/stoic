//
//  SearchView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
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
        textField.placeholder = "Search".lowercased().localized
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.smartInsertDeleteType = .no
        textField.backgroundColor = .clear
        textField.inputAccessoryView = collectionAccessory.container
        
        if #available(iOS 13.0, *) {
            textField.overrideUserInterfaceStyle = .dark
        }
        
        return textField
    }()
    
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
            top: GlobalStyle.spacing,
            left: GlobalStyle.padding,
            bottom: 0.0,
            right: GlobalStyle.padding)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    lazy var collectionAccessory: (
        collection: UICollectionView,
        container: UIView) = {
            
        let container: UIView = UIView.init(
            frame: CGRect.init(
                x: CGFloat.zero,
                y: CGFloat.zero,
                width: UIScreen.main.bounds.width,
                height: SearchStyle.cellSize.height*2))
        
        container.backgroundColor = GlobalStyle.Colors.black.withAlphaComponent(0.75)
        container.autoresizingMask = .flexibleWidth
        container.translatesAutoresizingMaskIntoConstraints = true
        
        let layout: UICollectionViewFlowLayout = .init()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = SearchStyle.itemSpacing
        layout.minimumLineSpacing = SearchStyle.lineSpacing
        layout.estimatedItemSize = SearchStyle.cellSize
        layout.headerReferenceSize = SearchStyle.headerCellSize
        
        let collection: UICollectionView = .init(
            frame: .zero,
            collectionViewLayout: layout)
        
        collection.contentInset = .init(
            top: GlobalStyle.spacing,
            left: GlobalStyle.spacing,
            bottom: 0.0,
            right: GlobalStyle.spacing)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        container.addSubview(collection)
            
        collection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return (collection, container)
    }()
    
    lazy var searchIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(style: .white)
        indicator.hidesWhenStopped = true
        return indicator
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
        
        addSubview(searchIndicator)
        
        searchIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(collection.snp.top).offset(GlobalStyle.spacing)
            make.size.equalTo(SearchStyle.searchSpinnerSize)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
    override public func hitTest(
        _ point: CGPoint,
        with event: UIEvent?) -> UIView? {
        let newPoint = point.applying(
            .init(
                translationX: self.frame.origin.x,
                y: self.frame.origin.y))
        
        if searchBoxTextField.isFirstResponder,
            !self.frame.contains(newPoint) {
            bubbleEvent(SearchEvents.SearchUpdateAppearance(intentToDismiss: true))
            resetSearch()
        } else if self.frame.contains(newPoint){
            bubbleEvent(SearchEvents.SearchUpdateAppearance())
        }
        
        return super.hitTest(point, with: event)
    }
    
    public func resetSearch() {
        searchBoxTextField.resignFirstResponder()
    }
}

//class TextFieldContainer: UIView {
//    weak var heightConstraint: Constraint?
//
//    override var intrinsicContentSize: CGSize {
//
//        let contentHeight = self.heightConstraint?.
//
//        return CGSize(width: UIScreen.main.bounds.width, height: contentHeight)
//    }
//}
