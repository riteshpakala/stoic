//
//  CollectionViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class LiveSearchCollectionViewController: GraniteViewController<LiveSearchCollectionState> {
    override public func loadView() {
        self.view = LiveSearchCollectionView.init()
    }
    
    public var _view: LiveSearchCollectionView {
        return self.view as! LiveSearchCollectionView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        _view.collection.delegate = self
        _view.collection.dataSource = self
        
        _view.collection.register(
            LiveSearchCollectionCell.self,
            forCellWithReuseIdentifier: "\(LiveSearchCollectionCell.self)")
        
        
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
	
}

extension LiveSearchCollectionViewController: UICollectionViewDelegate {
    
}

extension LiveSearchCollectionViewController: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(LiveSearchCollectionCell.self)",
            for: indexPath) as? LiveSearchCollectionCell else { return .init() }
        
        return cell
    }
}
