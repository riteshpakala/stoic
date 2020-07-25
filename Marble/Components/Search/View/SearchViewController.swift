//
//  SearchViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

public class SearchViewController: GraniteViewController<SearchState> {
    override public func loadView() {
        self.view = SearchView.init()
    }
    
    public var _view: SearchView {
        return self.view as! SearchView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        _view.collection.delegate = self
        _view.collection.dataSource = self
        
        _view.collection.register(
            SearchCollectionCell.self,
            forCellWithReuseIdentifier: "\(SearchCollectionCell.self)")
        
        _view.searchBoxTextField.delegate = self
        
        observeState(
            \.stocks,
            handler: observeStockSearchResults(_:),
            async: .main)
        observeState(
            \.stockResultsActive,
            handler: observeStockSearchActive(_:),
            async: .main)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
	
}

//MARK: Observers
extension SearchViewController {
    func observeStockSearchResults(
        _ stocks: Change<[SearchStock]>) {
        
        guard
            let count = stocks.newValue?.count,
            count > 0 else {
            
                
            return
        }
        
        _view.collection.reloadData()
        
        
    }
    
    func observeStockSearchActive(
        _ active: Change<Bool>) {
        
        guard active.newValue != active.oldValue else { return }
        
        if active.newValue == true {
            self._view.snp.remakeConstraints { make in
                make.top.equalTo((parent?.view ?? _view).safeAreaLayoutGuide.snp.top).offset(GlobalStyle.padding)
                make.left.equalTo((parent?.view ?? _view).safeAreaLayoutGuide.snp.left)
                make.right.equalTo((parent?.view ?? _view).safeAreaLayoutGuide.snp.right)
                make.height.equalTo(SearchStyle.searchSizeActive.height)
            }
            
            self._view.collection.snp.remakeConstraints { make in
                make.top.equalTo(_view.searchBoxContainerView.snp.bottom)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(SearchStyle.collectionHeight)
            }
        } else {
            self._view.snp.remakeConstraints { make in
                make.top.equalTo((parent?.view ?? _view).safeAreaLayoutGuide.snp.top).offset(GlobalStyle.padding)
                make.left.equalTo((parent?.view ?? _view).safeAreaLayoutGuide.snp.left)
                make.right.equalTo((parent?.view ?? _view).safeAreaLayoutGuide.snp.right)
                make.height.equalTo(SearchStyle.searchSizeInActive.height)
            }
            
            self._view.collection.snp.remakeConstraints { make in
                make.top.equalTo(_view.searchBoxContainerView.snp.bottom)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(0.0)
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(
        _ textField: UITextField) -> Bool {
        return true
    }
    public func textFieldShouldReturn(
        _ textField: UITextField) -> Bool {
        _view.searchBoxTextField.resignFirstResponder()
        return true
    }
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        
        sendEvent(SearchEvents.GetSearchResults(term: textField.text ?? string))
        
        return true
    }
    public func textFieldDidEndEditing(
        _ textField: UITextField) {
        
    }
}
extension SearchViewController: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
        if  let stocks = component?.state.stocks,
            indexPath.item < (component?.state.stocks.count ?? 0) {

            bubbleEvent(
                DashboardEvents.ShowDetail(
                    searchedStock: stocks[indexPath.item]))
        }
    }
}
extension SearchViewController: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return component?.state.stocks.count ?? 0
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(SearchCollectionCell.self)",
            for: indexPath) as? SearchCollectionCell else { return .init() }
        
        if let stock = component?.state.stocks[indexPath.item] {
            cell.tickerLabel.text = stock.symbol
        }
        
        return cell
    }
}
