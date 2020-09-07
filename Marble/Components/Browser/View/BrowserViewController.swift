//
//  BrowserViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class BrowserViewController: GraniteViewController<BrowserState> {
    private(set) lazy var dataSource: ManagedObjectDataSource<StockModelMergedObject>? = {
        
        guard let context = component?.service.center.coreData.main else {
            return nil
        }
        let dataSource = ManagedObjectDataSource<StockModelMergedObject>(
            context: context,
            sortDescriptors: [NSSortDescriptor.init(
                keyPath: \StockModelMergedObject.order,
                ascending: true)])
        
        return dataSource
    }()
    
    override public func loadView() {
        self.view = BrowserView.init()
    }
    
    public var _view: BrowserView {
        return self.view as! BrowserView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        _view.collection.view.delegate = self
        _view.collection.view.register(
            BrowserModelCell.self,
            forCellWithReuseIdentifier: identify(BrowserModelCell.self))
        
        self.dataSource?.register(
            collectionView: _view.collection.view,
            process: { [weak self] (collectionView, indexPath, object) -> UICollectionViewCell in
                guard
                    let this = self
                    else {
                        return collectionView.dequeueReusableCell(
                            withReuseIdentifier: identify(BrowserModelCell.self),
                            for: indexPath)
                }
                return this.processCell(
                    collectionView,
                    indexPath: indexPath,
                    object: object)
        })
        
        self.dataSource?.performFetch()
    }
    
    private func processCell(
        _ collectionView: UICollectionView,
        indexPath: IndexPath,
        object: StockModelMergedObject
    ) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: identify(BrowserModelCell.self),
                for: indexPath)
        
        guard let browserModelCell = cell as? BrowserModelCell else {
            return cell
        }
        
        print("{CoreData} \(object.stock.asSearchStock?.symbol)")
        browserModelCell.valueLabel.text = object.stock.asSearchStock?.symbol
        
        return browserModelCell
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

extension BrowserViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return  .init(width: 50, height: 50)
    }
}

extension BrowserViewController: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
    }
}
