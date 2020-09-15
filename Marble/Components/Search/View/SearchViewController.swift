//
//  SearchViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit
import Firebase

public class SearchViewController: GraniteViewController<SearchState> {
    var isOnline: Bool {
        return component?.service.center.isOnline == true
    }
    
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
        
        _view.collectionAccessory.collection.delegate = self
        _view.collectionAccessory.collection.dataSource = self
        
        _view.collectionAccessory.collection.register(
            SearchCollectionCell.self,
            forCellWithReuseIdentifier: "\(SearchCollectionCell.self)")
        _view.collectionAccessory.collection.register(
            SearchCollectionHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "\(SearchCollectionHeaderCell.self)")
        
        _view.searchBoxTextField.delegate = self
        
        observeState(
            \.stocks,
            handler: observeStockSearchResults(_:),
            async: .main)
        
        observeState(
            \.isLoadingRotation,
            handler: observeStockRotation(_:),
            async: .main)
        
        observeState(
            \.searchTimer,
            handler: observeSearchStatus(_:),
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
        _view.collection.reloadData()
    }
    
    func observeStockRotation(
        _ stocks: Change<Bool>) {
        
        guard stocks.newValue == false else { return }
        _view.collectionAccessory.collection.reloadData()
    }
    
    func observeSearchStatus(
        _ searchTimer: Change<Timer?>) {
        
        if  let value = searchTimer.newValue,
            value != nil {
            _view.searchIndicator.startAnimating()
        } else {
            _view.searchIndicator.stopAnimating()
        }
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
        component?.sendEvent(SearchEvents.GenerateStockRotation.live)
        return true
    }
    
    public func textFieldShouldReturn(
        _ textField: UITextField) -> Bool {
        
        _view.resetSearch()
        
        if component?.service.center.onboardingDashboardCompleted == true {
            bubbleEvent(SearchEvents.SearchUpdateAppearance(intentToDismiss: true))
        }
        
        return true
    }
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text else { return true }
        
        let text: String
        if range.location >= textFieldText.count {
            text = textFieldText + string
        } else {
            text = (textFieldText as NSString).replacingCharacters(
                in: NSRange.init(location: range.location, length: range.length),
                with: string) as String
        }

        sendEvent(SearchEvents.GetSearchResults(term: text))
        
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
        
        let stocks: Array<SearchStock>
        
        if collectionView == _view.collection {
            stocks = component?.state.stocks ?? []
        } else {
            stocks = component?.state.stockRotation ?? []
        }
        
        guard indexPath.item < stocks.count else { return }
        
        let stock: SearchStock = stocks[indexPath.item]
        
        if collectionView == _view.collection {
            guard isStockAvailable(stock) else {
                bubbleEvent(SubscribeEvents.Show())
                return
            }
            
            if let id = Auth.auth().currentUser?.uid {
                component?.service.center.backend.put(
                    stock,
                    route: .global,
                    server: .search,
                    key: id)
            }
            
            component?.service.center.backend.put(
                stock,
                route: .general,
                server: .search)
            
            bubbleEvent(
                DashboardEvents.ShowDetail.search(stock))
        } else if component?.service.center.onboardingDashboardCompleted == true {
            
            bubbleEvent(
                DashboardEvents.ShowDetail.search(stock))
        }
    }
}
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView == _view.collectionAccessory.collection {
            if isOnline {
                return SearchStyle.headerCellSize
            } else {
                return SearchStyle.headerCellSizeOffline
            }
        } else {
            return .zero
        }
    }
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        if collectionView == _view.collection {
            return component?.state.stocks.isEmpty == true ? 1 : (component?.state.stocks.count ?? 0)
        } else if collectionView == _view.collectionAccessory.collection {
            return component?.state.stockRotation.isEmpty == true ? 1 : (component?.state.stockRotation.count ?? 0)
        } else {
            return 1
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(SearchCollectionCell.self)",
            for: indexPath) as? SearchCollectionCell else { return .init() }
        
        
        
        if collectionView == _view.collection,
            indexPath.item < (component?.state.stocks.count ?? 0),
            let stock = component?.state.stocks[indexPath.item]
        {
            cell.tickerLabel.text = stock.symbol
            cell.isAvailable = isStockAvailable(stock)
        } else if collectionView == _view.collectionAccessory.collection,
            indexPath.item < (component?.state.stockRotation.count ?? 0),
            let stock = component?.state.stockRotation[indexPath.item]
        {
            cell.tickerLabel.text = stock.symbol
            cell.isAvailable = isStockAvailable(stock)
        } else {
            cell.tickerLabel.text = "none found".lowercased().localized
        }
        
        return cell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard collectionView == _view.collectionAccessory.collection else {
            return .init()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "\(SearchCollectionHeaderCell.self)",
            for: indexPath)
        
        if let searchHeaderCell = header as? SearchCollectionHeaderCell {
            let subscription: GlobalDefaults.Subscription = GlobalDefaults.Subscription.from(component?.state.subscription)
            searchHeaderCell.isPRO = subscription.isActive
            searchHeaderCell.isOffline = !isOnline
        }
        
        return header
    }
    
    private func isStockAvailable(_ stock: SearchStock) -> Bool {
        let symbol = stock.symbol
        let subscription: GlobalDefaults.Subscription = GlobalDefaults.Subscription.from(component?.state.subscription)
        let stockRotation: [String] = component?.state.stockRotation.compactMap({ $0.symbol }) ?? []
        
        return stockRotation.contains(symbol) || subscription.isActive
    }
}
