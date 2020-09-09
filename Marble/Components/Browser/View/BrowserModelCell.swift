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
    lazy var tickerContainer: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .clear
//        view.layer.borderWidth = 2.0
//        view.layer.borderColor = GlobalStyle.Colors.graniteGray.cgColor
        return view
    }()
    
    lazy var tickerLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.large, .bold)
        label.textAlignment = .left
        label.textColor = GlobalStyle.Colors.green
        return label
    }()
    
    lazy var standaloneLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .left
        label.text = "// standalone".localized.lowercased()
        label.textColor = GlobalStyle.Colors.green
        return label
    }()
    
    lazy var compiledLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .left
        label.text = "// compiled".localized.lowercased()
        label.textColor = GlobalStyle.Colors.green
        return label
    }()
    
    lazy var compiledActionLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .left
        label.textColor = GlobalStyle.Colors.green
        return label
    }()
    
    lazy var compiledTradingDayLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .right
        label.textColor = GlobalStyle.Colors.black
        return label
    }()
    
    lazy var compiledDaysLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .right
        label.textColor = GlobalStyle.Colors.black
        return label
    }()
    
    lazy var compiledModelsWithinLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .left
        label.textColor = GlobalStyle.Colors.black
        return label
    }()
    
    lazy var compiledActionStackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                compiledActionLabel
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.spacing
        
        return view
    }()
    
    lazy var compiledInfoStackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                compiledTradingDayLabel,
                compiledDaysLabel,
                compiledModelsWithinLabel
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.spacing
        
        return view
    }()
    
    lazy var compiledContainerStackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                compiledActionStackView,
                compiledInfoStackView
            ]
        )
        
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.spacing
        
        return view
    }()
    
    lazy var compiledContainerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = GlobalStyle.Colors.marbleBrown
        view.layer.cornerRadius = 4.0
        view.layer.borderWidth = 2.0
        return view
    }()
    
    lazy var compiledStackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                compiledLabel,
                compiledContainerView
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.padding
        
        return view
    }()
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                tickerContainer,
                compiledStackView,
                standaloneLabel,
                collection.view
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.largePadding
        view.setCustomSpacing(GlobalStyle.padding, after: standaloneLabel)
        
        return view
    }()
    
    var model: StockModelMergedObject? = nil {
        didSet {
            compiledTradingDayLabel.text = "test"
            compiledDaysLabel.text = "144"
            compiledModelsWithinLabel.text = "12"
            compiledActionLabel.text = "Action"
            
            stock = model?.stock.asSearchStock ?? SearchStock.init(exchangeName: "unknown", symbolName: "unknown", companyName: "unknown")
            guard let models = model?.models else { return }
            
            var stockModels: [StockModel] = []
            var stockModelsDict: [String: [StockModel]] = [:]
            for item in models {
                if let stockModelObject = item as? StockModelObject {
                    let stockModel = StockModel.init(from: stockModelObject)
                    
                    if stockModelsDict.keys.contains(stockModel.tradingDay) {
                        stockModelsDict[stockModel.tradingDay]?.append(stockModel)
                    } else {
                        stockModelsDict[stockModel.tradingDay] = [stockModel]
                    }
                    
                    stockModels.append(stockModel)
                }
            }
            
            let sortedKeys = Array(stockModelsDict.keys)
                .sorted(by: {
                    ($0.asDate() ?? Date())
                        .compare(($1.asDate() ?? Date())) == .orderedDescending })
            self.stockKeys = sortedKeys
            self.stockModels = stockModelsDict
        }
    }
    
    var stock: SearchStock? = nil {
        didSet {
            tickerLabel.text = stock?.symbol
        }
    }
    
    var stockKeys: [String] = []
    
    var stockModels: [String: [StockModel]] = [:] {
        didSet {
            guard !stockKeys.isEmpty else { return }
            DispatchQueue.main.async {
                print("{Browser} \(self.stockModels.count)")
                self.collection.view.reloadData()
            }
        }
    }
    
    lazy var maxDays: Int = {
        return PredictionRules.init().maxDays
    }()
    
    private(set) lazy var collection: (
        view: UICollectionView,
        layout: UICollectionViewLayout) = {

        let layout: UICollectionViewLayout
        let flowLayout = UICollectionViewFlowLayout()
        
        
        flowLayout.minimumInteritemSpacing = GlobalStyle.padding
        flowLayout.minimumLineSpacing = GlobalStyle.padding
        flowLayout.scrollDirection = .vertical
                
        layout = flowLayout

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.isPrefetchingEnabled = false
        view.isPagingEnabled = false
        
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
            BrowserModelContainerDataCell.self,
            forCellWithReuseIdentifier: identify(BrowserModelContainerDataCell.self))
        collection.view.register(
            BrowserModelCellHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: identify(BrowserModelCellHeader.self))
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        compiledContainerView.snp.makeConstraints { make in
            make.height.equalTo(BrowserStyle.browserDataCellHeight)
        }
        
        compiledContainerView.addSubview(compiledContainerStackView)
        compiledContainerStackView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(GlobalStyle.padding)
            make.bottom.right.equalToSuperview().offset(-GlobalStyle.padding)
        }
        tickerContainer.snp.makeConstraints { make in
            make.height.equalTo(tickerLabel.font.lineHeight)
            
        }
        tickerContainer.addSubview(tickerLabel)
        tickerLabel.snp.makeConstraints { make in
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
        
        tickerLabel.text = ""
        stockModels = [:]
        stock = nil
    }
}

extension BrowserModelCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return stockKeys.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableView = collectionView
            .dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: identify(BrowserModelCellHeader.self),
                for: indexPath)
        
        if let view = reusableView as? BrowserModelCellHeader {
            view.dateLabel.text = "- "+stockKeys[indexPath.section]
            view.modelsWithinLabel.text = "\(stockModels[stockKeys[indexPath.section]]?.count ?? 0)"
            
            return view
        } else {
            return reusableView
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let reusableView = collectionView
            .dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: identify(BrowserModelCellHeader.self),
                for: IndexPath.init(item: 0, section: section))
        
        if let view = reusableView as? BrowserModelCellHeader {
            return .init(
                width: collectionView.frame.size.width,
                height: view.dateLabel.font.lineHeight + GlobalStyle.padding)
        } else {
            return .zero
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: identify(BrowserModelContainerDataCell.self),
                for: indexPath)
        
        guard let dataCell = cell as? BrowserModelContainerDataCell else {
            return cell
        }
        
        dataCell.models = stockModels[stockKeys[indexPath.section]]
        
        return dataCell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return  .init(
            width: self.frame.size.width,
            height: BrowserStyle.browserDataCellHeight)
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

class BrowserModelCellHeader: UICollectionReusableView {
    
    lazy var dateLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textColor = GlobalStyle.Colors.orange
        label.textAlignment = .left
        return label
    }()
    
    lazy var modelsWithinLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textColor = GlobalStyle.Colors.orange
        label.textAlignment = .right
        return label
    }()
    
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                dateLabel,
                modelsWithinLabel
            ]
        )
        
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.spacing
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
