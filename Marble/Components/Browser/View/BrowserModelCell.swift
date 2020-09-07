//
//  BrowserModelCell.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class BrowserModelCell: UICollectionViewCell {
    lazy var valueContainer: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .clear
//        view.layer.borderWidth = 2.0
//        view.layer.borderColor = GlobalStyle.Colors.graniteGray.cgColor
        return view
    }()
    
    lazy var valueLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.large, .bold)
        label.textAlignment = .left
        label.textColor = GlobalStyle.Colors.green
        return label
    }()
    
    var model: StockModelMergedObject? = nil {
        didSet {
            stock = model?.stock.asSearchStock ?? SearchStock.init(exchangeName: "unknown", symbolName: "unknown", companyName: "unknown")
            guard let models = model?.models else { return }
            
            var stockModels: [StockModel] = []
            for item in models {
                if let stockModelObject = item as? StockModelObject {
                    let stockModel = StockModel.init(from: stockModelObject)
                    stockModels.append(stockModel)
                }
            }
            self.stockModels = stockModels
        }
    }
    
    var stock: SearchStock? = nil {
        didSet {
            valueLabel.text = stock?.symbol
        }
    }
    
    var stockModels: [StockModel] = [] {
        didSet {
            maxDayOfCells = CGFloat(self.stockModels.map({ $0.days }).max() ?? 0)
            
            DispatchQueue.main.async {
                print("{Browser} \(self.stockModels.count)")
                self.collection.view.reloadData()
            }
        }
    }
    
    lazy var maxDays: Int = {
        return PredictionRules.init().maxDays
    }()
    
    var maxDayOfCells: CGFloat = 1
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                valueContainer,
                collection.view
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.spacing
        
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
        
        view.contentInsetAdjustmentBehavior = .never
        return (view, layout)
    }()
    
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
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        valueContainer.snp.makeConstraints { make in
            make.height.equalTo(valueLabel.font.lineHeight)
            
        }
        valueContainer.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
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
        
        valueLabel.text = ""
        stockModels = []
        stock = nil
    }
}

extension BrowserModelCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return stockModels.count
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
        
        dataCell.model = stockModels[indexPath.item]
        
        return dataCell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let daysOfStockModel = stockModels[indexPath.item].days
        let widthOfFrame = self.frame.size.width
        let widthOfStockVersusMax = floor((CGFloat(daysOfStockModel)/CGFloat(maxDayOfCells))*widthOfFrame)
        
        return  .init(
            width: widthOfStockVersusMax,
            height: collectionView.frame.height)
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
    
    var estimatedSize: CGSize {
        self.stackView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
    }
}
