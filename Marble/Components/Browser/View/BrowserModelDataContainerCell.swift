//
//  BrowserModelDataContainerCell.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/8/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import Granite
import Foundation
import UIKit

public class BrowserModelContainerDataCell: UICollectionViewCell {
    private(set) lazy var collection: (
        view: UICollectionView,
        layout: UICollectionViewLayout) = {

        let layout: UICollectionViewLayout
        let flowLayout = UICollectionViewFlowLayout()
        
        
        flowLayout.minimumInteritemSpacing = GlobalStyle.spacing
        flowLayout.minimumLineSpacing = GlobalStyle.padding
        flowLayout.scrollDirection = .horizontal
        layout = flowLayout

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.isPrefetchingEnabled = false
        view.isPagingEnabled = true
        
        view.contentInsetAdjustmentBehavior = .never
        return (view, layout)
    }()
    
    var models: [StockModel]? = nil {
        didSet {
            DispatchQueue.main.async {
                self.collection.view.reloadData()
            }
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collection.view.dataSource = self
        collection.view.delegate = self
        collection.view.register(
                   BrowserModelDataCell.self,
                   forCellWithReuseIdentifier: identify(BrowserModelDataCell.self))
        
        contentView.addSubview(collection.view)
        collection.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override public func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        models = nil
    }
}

extension BrowserModelContainerDataCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: identify(BrowserModelDataCell.self),
                for: indexPath)
        
        guard let dataCell = cell as? BrowserModelDataCell else {
            return cell
        }
        
        if let models = models {
            dataCell.model = models[indexPath.item]
        }
        
        return dataCell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let models = self.models else { return .zero }
        let ratio: CGFloat
        if models.count > 1 {
            ratio = BrowserStyle.browserDataModelMultipleCellWidthRatio
        } else {
            ratio = 1.0
        }
        return  .init(
            width: self.frame.size.width*ratio,
            height: self.frame.size.height)
    }
    
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
