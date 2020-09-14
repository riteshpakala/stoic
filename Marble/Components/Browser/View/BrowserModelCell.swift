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
    //MARK: Labels and headers
    
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
    
    //MARK: Compiled Section [ ACTION ]
    
    //Added to container view, not stack if no compiled model found
    lazy var compiledCreateLabel: PaddingLabel = {
        let view: PaddingLabel = .init(
            UIEdgeInsets.init(
                top: 0,
                left: GlobalStyle.spacing*2,
                bottom: 0.0,
                right: GlobalStyle.spacing*2))
        view.text = "create".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.layer.borderColor = GlobalStyle.Colors.orange.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 4.0
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        view.sizeToFit()
        
        return view
    }()
    
    private var longPressGesture: UILongPressGestureRecognizer {
        let gesture:UILongPressGestureRecognizer = .init(target: self, action: #selector(self.mergedModelLongPressed(_:)))
        gesture.cancelsTouchesInView = true
        return gesture
    }
    
    lazy var idLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .left
        label.textColor = GlobalStyle.Colors.black
        return label
    }()
    
    //Compiled Section's action (syncing) (CompiledActionStackView)
    lazy var syncButton: PaddingLabel = {
        let view: PaddingLabel = .init(
            UIEdgeInsets.init(
                top: 0,
                left: GlobalStyle.spacing*2,
                bottom: 0.0,
                right: GlobalStyle.spacing*2))
        view.text = "sync".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.black
        view.layer.borderColor = GlobalStyle.Colors.black.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 4.0
        view.textAlignment = .center
        view.isUserInteractionEnabled = false
        view.sizeToFit()
        view.isHidden = true
        return view
    }()
    
    lazy var loadButton: PaddingLabel = {
        let view: PaddingLabel = .init(
            UIEdgeInsets.init(
                top: 0,
                left: GlobalStyle.spacing*2,
                bottom: 0.0,
                right: GlobalStyle.spacing*2))
        view.text = "load".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.layer.borderColor = GlobalStyle.Colors.orange.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 4.0
        view.textAlignment = .center
        view.isUserInteractionEnabled = false
        view.sizeToFit()
        view.isHidden = true
        return view
    }()
    
    lazy var staleButton: PaddingLabel = {
        let view: PaddingLabel = .init(
            UIEdgeInsets.init(
                top: 0,
                left: GlobalStyle.spacing*2,
                bottom: 0.0,
                right: GlobalStyle.spacing*2))
        view.text = "stale".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        view.textColor = GlobalStyle.Colors.black
        view.layer.borderColor = GlobalStyle.Colors.black.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 4.0
        view.textAlignment = .center
        view.isUserInteractionEnabled = false
        view.sizeToFit()
        view.isHidden = true
        return view
    }()
    
    lazy var actionsContainerView: UIView = {
        let view: UIView = .init()
        
        return view
    }()
    
    //Compiled Section's action stack (left side)
    lazy var compiledActionStackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                idLabel,
                actionsContainerView
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.spacing
        
        return view
    }()
    
    //MARK: Compiled Section [ INFO ]
    
    //Compiled Section's trading days count (CompiledInfoStackView)
    lazy var compiledTradingDayLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .right
        label.textColor = GlobalStyle.Colors.black
        return label
    }()
    
    //Compiled Section's total days count (CompiledInfoStackView)
    lazy var compiledDaysLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .right
        label.textColor = GlobalStyle.Colors.black
        return label
    }()
    
    //Compiled Section's information stack model count (CompiledInfoStackView)
    lazy var compiledModelsWithinLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.textAlignment = .right
        label.textColor = GlobalStyle.Colors.black
        return label
    }()
    
    //Compiled Section's information stack (right side)
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
        view.distribution = .fillEqually
        view.spacing = GlobalStyle.spacing
        
        return view
    }()
    
    //MARK: Compiled Section { CONTAINER }
    
    //Compiled Section's stack view for an existing
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
    
    //Compiled Section's container for the stack view of existing
    lazy var compiledContainerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = GlobalStyle.Colors.marbleBrown
        view.layer.cornerRadius = 4.0
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.clear.cgColor
        return view
    }()
    
    //MARK: Compiled Creation Section [ Details ]
    //Goes into Main Stack View and appears as pseudo footer of collection
    //(below collection
    
    //Compiled Section's container for the container below collection view for
    //completing creation steps
    lazy var compiledCreateDetailsContainerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 4.0
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.clear.cgColor
        view.isHidden = true
        return view
    }()
    
    lazy var compiledCreationCancelLabel: PaddingLabel = {
        let view: PaddingLabel = .init(
            UIEdgeInsets.init(
                top: 0,
                left: GlobalStyle.spacing*2,
                bottom: 0.0,
                right: GlobalStyle.spacing*2))
        view.text = "cancel".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.layer.borderColor = GlobalStyle.Colors.orange.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 4.0
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        view.sizeToFit()
        
        return view
    }()
    
    lazy var compiledCreationDoneLabel: PaddingLabel = {
        let view: PaddingLabel = .init(
            UIEdgeInsets.init(
                top: 0,
                left: GlobalStyle.spacing*2,
                bottom: 0.0,
                right: GlobalStyle.spacing*2))
        view.text = "done".localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.layer.borderColor = GlobalStyle.Colors.orange.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 4.0
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        view.sizeToFit()
        
        return view
    }()
    
    lazy var compiledCreationStatusLabel: UILabel = {
        let view: UILabel = .init()
        view.text = currentCreationStatusStep.rawValue.localized.lowercased()
        view.font = GlobalStyle.Fonts.courier(.medium, .bold)
        view.textColor = GlobalStyle.Colors.orange
        view.textAlignment = .center
        view.isUserInteractionEnabled = true
        view.sizeToFit()
        
        return view
    }()
    
    var currentCreationStatusStep: BrowserCompiledModelCreationStatus = .none {
        didSet {
            self.compiledCreationStatusLabel.text = currentCreationStatusStep.rawValue.localized.lowercased()
            
            for cell in self.collection.view.visibleCells {
                if let dataCell = cell as? BrowserModelDataContainerCell {
                    dataCell.currentCreationStatusStep = currentCreationStatusStep
                }
            }
            
            switch currentCreationStatusStep {
            case .step1:
                hideViewsForCreation()
                compiledCreationDoneLabel.text = "done".localized.lowercased()
                compiledCreationDoneLabel.sizeToFit()
                widthOfDoneLabel?.update(offset: compiledCreationDoneLabel.frame.size.width + GlobalStyle.spacing*4)
            case .step2, .update:
                hideViewsForCreation()
                compiledCreationDoneLabel.text = "confirm".localized.lowercased()
                compiledCreationDoneLabel.sizeToFit()
                widthOfDoneLabel?.update(offset: compiledCreationDoneLabel.frame.size.width + GlobalStyle.spacing*4)
            case .step3:
                break
            default:
                showViewForCreation()
                compiledCreationDoneLabel.text = "done".localized.lowercased()
                compiledCreationDoneLabel.sizeToFit()
                widthOfDoneLabel?.update(offset: compiledCreationDoneLabel.frame.size.width + GlobalStyle.spacing*4)
            }
        }
    }
    var compiledModelCreationData: BrowserCompiledModelCreationData? = nil {
        didSet {
            for cell in self.collection.view.visibleCells {
                if let dataCell = cell as? BrowserModelDataContainerCell {
                    dataCell.compiledModelCreationData = compiledModelCreationData
                }
            }
        }
    }
    
    //MARK: Compiled Section Stack { MAIN }
    
    lazy var compiledLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .left
        label.text = "// compiled".localized.lowercased()
        label.textColor = GlobalStyle.Colors.green
        return label
    }()
    
    //Compiled Stack View
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
    
    //MARK: MAIN Container
    
    
    //MARK: Collection View [ MAIN ]
    private(set) lazy var collection: (
        view: UICollectionView,
        layout: UICollectionViewLayout) = {
            
        let layout: UICollectionViewLayout
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.sectionInset = .init(top: 0.0, left: 0.0, bottom: GlobalStyle.padding, right: 0.0)
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
    
    //Main Stack View
    lazy var stackView: GraniteStackView = {
        let view: GraniteStackView = GraniteStackView.init(
            arrangedSubviews: [
                tickerContainer,
                compiledStackView,
                standaloneLabel,
                collection.view,
                compiledCreateDetailsContainerView,
                spacer
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.largePadding
        view.setCustomSpacing(GlobalStyle.padding, after: standaloneLabel)
        
        return view
    }()
    
    lazy var spacer: UIView = {
        let view = UIView.init()
        view.isHidden = true
        return view
    }()
    
    //MARK: Model
    
    var model: StockModelMergedObject? = nil {
        didSet {
            
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
            
            //Update Compiled Model Data
            if model?.model != nil {
                guard let models = model?.models,
                      let ids = model?.currentModels?.mergedModelIDs else { return }
                
                let stockModelObjs: [StockModelObject] = models.compactMap({ ids.contains(($0 as? StockModelObject)?.id ?? "") ? ($0 as? StockModelObject) : nil })
                
                let stockModels: [StockModel] = stockModelObjs.map({ StockModel.init(from: $0) })
                
                let sortedStockModels = stockModels.sorted(by: {
                    ($0.tradingDayDate)
                        .compare(($1.tradingDayDate)) == .orderedDescending })
                
                guard let firstModel = sortedStockModels.first else { return }
                
                compiledTradingDayLabel.text = "\(firstModel.tradingDay)"
                compiledDaysLabel.text = "\("days trained".localized.lowercased()): "+"\(stockModels.map { $0.days }.reduce(0, +))"
                compiledModelsWithinLabel.text = "\("models within".localized.lowercased()): "+"\(stockModels.count)"
                idLabel.text = "\((model?.id.components(separatedBy: "-").last ?? "").lowercased())"
                
                compiledContainerStackView.isHidden = false
                compiledCreateLabel.isHidden = true
                compiledContainerView.backgroundColor = GlobalStyle.Colors.marbleBrown
                longPressGesture.isEnabled = true
            } else {
                compiledContainerStackView.isHidden = true
                compiledCreateLabel.isHidden = false
                compiledContainerView.backgroundColor = .clear
                longPressGesture.isEnabled = false
            }
        }
    }
    
    var lifecycle: StockModelMerged.Lifecycle = .none {
        didSet {
            switch lifecycle {
            case .isReady:
                compiledContainerView.backgroundColor = GlobalStyle.Colors.marbleBrown
                staleButton.isHidden = true
                syncButton.isHidden = true
                loadButton.isHidden = false
            case .isStale:
                compiledContainerView.backgroundColor = GlobalStyle.Colors.graniteGray
                staleButton.isHidden = false
                syncButton.isHidden = true
                loadButton.isHidden = true
            case .needsSyncing:
                compiledContainerView.backgroundColor = GlobalStyle.Colors.purple
                staleButton.isHidden = true
                syncButton.isHidden = false
                loadButton.isHidden = true
            default: break
            }
        }
    }
    
    var isCreating: Bool {
        currentCreationStatusStep != .none
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
                self.collection.view.reloadData()
            }
        }
    }
    
    lazy var maxDays: Int = {
        return PredictionRules.init().maxDays
    }()
    
    //MARK: Gestures
    private var mergeModelTappedGesture: UITapGestureRecognizer {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer
            .init(target: self,
                  action: #selector(self.mergedModelTapped(_:)))
        
        return gesture
    }
    
    private var createTappedGesture: UITapGestureRecognizer {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer
            .init(target: self,
                  action: #selector(self.createTapped(_:)))
        
        return gesture
    }
    
    private var cancelTappedGesture: UITapGestureRecognizer {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer
            .init(target: self,
                  action: #selector(self.cancelTapped(_:)))
        
        return gesture
    }
    
    private var doneTappedGesture: UITapGestureRecognizer {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer
            .init(target: self,
                  action: #selector(self.doneTapped(_:)))
        
        return gesture
    }
    
    private var widthOfDoneLabel: Constraint?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collection.view.dataSource = self
        collection.view.delegate = self
        collection.view.register(
            BrowserModelDataContainerCell.self,
            forCellWithReuseIdentifier: identify(BrowserModelDataContainerCell.self))
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
        
        compiledContainerView.addSubview(compiledCreateLabel)
        compiledCreateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(compiledCreateLabel.frame.size.width + GlobalStyle.spacing*4)
            make.height.equalTo(compiledCreateLabel.font.lineHeight + GlobalStyle.spacing*2)
        }
        compiledCreateLabel.addGestureRecognizer(createTappedGesture)
        
        compiledCreateDetailsContainerView.snp.makeConstraints { make in
            make.height.equalTo(
                BrowserStyle.browserDataCellHeight+compiledCreationStatusLabel.font.lineHeight)
        }
        compiledCreateDetailsContainerView.addSubview(compiledCreationStatusLabel)
        compiledCreateDetailsContainerView.addSubview(compiledCreationCancelLabel)
        compiledCreateDetailsContainerView.addSubview(compiledCreationDoneLabel)
        compiledCreationStatusLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY
                .equalToSuperview()
                .offset(-1*(compiledCreationStatusLabel.font.lineHeight/2 + GlobalStyle.spacing*2))
            make.left.right.equalToSuperview()
            make.height.equalTo(compiledCreationDoneLabel.font.lineHeight + GlobalStyle.spacing*2)
        }
        compiledCreationCancelLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY
                .equalToSuperview()
                .offset(compiledCreationStatusLabel.font.lineHeight/2 + GlobalStyle.spacing*2)
            make.width.equalTo(compiledCreationCancelLabel.frame.size.width + GlobalStyle.spacing*4)
            make.height.equalTo(compiledCreationCancelLabel.font.lineHeight + GlobalStyle.spacing*2)
        }
        compiledCreationDoneLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY
                .equalToSuperview()
                .offset(compiledCreationStatusLabel.font.lineHeight/2 + GlobalStyle.spacing*2)
            widthOfDoneLabel = make.width.equalTo(compiledCreationDoneLabel.frame.size.width + GlobalStyle.spacing*4).constraint
            make.height.equalTo(compiledCreationDoneLabel.font.lineHeight + GlobalStyle.spacing*2)
        }
        spacer.snp.makeConstraints { make in
            make.height.equalTo(self.contentView.safeAreaInsets.bottom)
        }
        actionsContainerView.addSubview(syncButton)
        syncButton.snp.makeConstraints { make in
            make.height.equalTo(syncButton.font.lineHeight+(GlobalStyle.spacing*2))
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(syncButton.frame.size.width+(GlobalStyle.spacing*4))
        }
        actionsContainerView.addSubview(loadButton)
        loadButton.snp.makeConstraints { make in
            make.height.equalTo(loadButton.font.lineHeight+(GlobalStyle.spacing*2))
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(loadButton.frame.size.width+(GlobalStyle.spacing*4))
        }
        actionsContainerView.addSubview(staleButton)
        staleButton.snp.makeConstraints { make in
            make.height.equalTo(staleButton.font.lineHeight+(GlobalStyle.spacing*2))
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(staleButton.frame.size.width+(GlobalStyle.spacing*4))
        }
        compiledCreationCancelLabel.addGestureRecognizer(cancelTappedGesture)
        compiledCreationDoneLabel.addGestureRecognizer(doneTappedGesture)
        compiledContainerView.addGestureRecognizer(mergeModelTappedGesture)
        compiledContainerView.addGestureRecognizer(longPressGesture)
    }
    
    override public func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        stackView.layoutIfNeeded()
        collection.layout.invalidateLayout()
        
        if self.orientationIsIPhoneLandscape {
            hideViewsForLandscape()
        } else if self.orientationIsIPhonePortrait {
            showViewForLandscape()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        
        tickerLabel.text = ""
        stockModels = [:]
        stock = nil
        compiledTradingDayLabel.text = ""
        compiledDaysLabel.text = ""
        compiledModelsWithinLabel.text = ""
        syncButton.isHidden = true
        loadButton.isHidden = true
        compiledContainerStackView.isHidden = true
        compiledCreateLabel.isHidden = true
        longPressGesture.isEnabled = false
        
        
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
                withReuseIdentifier: identify(BrowserModelDataContainerCell.self),
                for: indexPath)
        
        guard let dataCell = cell as? BrowserModelDataContainerCell else {
            return cell
        }
        
        dataCell.models = stockModels[stockKeys[indexPath.section]]
        dataCell.currentCreationStatusStep = self.currentCreationStatusStep
        
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

//MARK: Compiled Model Creation Flow
extension BrowserModelCell {
    @objc func mergedModelLongPressed(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began, currentCreationStatusStep == BrowserCompiledModelCreationStatus.none else { return }
        
        impactOccured()
        let controller = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let create: UIAlertAction = .init(title: "new model".localized.lowercased(), style: .destructive, handler: { [weak self] alert in
            
            DispatchQueue.main.async {
                self?.compiledContainerView.undim()
            }
            self?.bubble(BrowserEvents.CompiledModelCreationStatusUpdated.init(.step1, stock: self?.model?.stock.asSearchStock))
        })
        
        let cancel: UIAlertAction = .init(title: "cancel", style: .cancel, handler: { [weak self] alert in
            DispatchQueue.main.async {
                self?.compiledContainerView.undim()
            }
        })
        
        controller.addAction(create)
        controller.addAction(cancel)
        
        self.compiledContainerView.dim()
        
        bubble(HomeEvents.PresentAlertController.init(controller))
    }
    
    @objc func mergedModelTapped(_ sender: UITapGestureRecognizer) {
        guard let model = model else { return }
        impactOccured()
        guard lifecycle == .isReady else {
            didSelectUnPreparedModel()
            return
        }
        
        bubble(BrowserEvents.MergeModelSelected.init(model, self.lifecycle))
    }
    
    @objc func createTapped(_ sender: UITapGestureRecognizer) {
        guard !self.collection.view.isDecelerating else { return }
        impactOccured()
        bubble(BrowserEvents.CompiledModelCreationStatusUpdated.init(.step1, stock: self.model?.stock.asSearchStock))
    }
    
    @objc func cancelTapped(_ sender: UITapGestureRecognizer) {
        impactOccured()
        bubble(BrowserEvents.CompiledModelCreationStatusUpdated.init(.none, stock: self.model?.stock.asSearchStock))
    }
    
    @objc func doneTapped(_ sender: UITapGestureRecognizer) {
        switch currentCreationStatusStep {
        case .step1:
            impactOccured()
            guard compiledModelCreationData != nil else { return }
            bubble(BrowserEvents.CompiledModelCreationStatusUpdated.init(.step2, stock: self.model?.stock.asSearchStock))
        case .step2, .update:
            impactOccured()
            bubble(BrowserEvents.CompiledModelCreationStatusUpdated.init(.step3, stock: self.model?.stock.asSearchStock))
        default:
            break
        }
    }
    
    func didSelectUnPreparedModel() {
        let controller = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let train: UIAlertAction = .init(title: "train new model".localized.lowercased(), style: .default, handler: { [weak self] alert in
            
            DispatchQueue.main.async {
                self?.compiledContainerView.undim()
            }
            
            if let model = self?.model, let lifecycle = self?.lifecycle {

                self?.bubble(BrowserEvents.MergeModelSelected.init(model, lifecycle))
            }
        })
        
        let update: UIAlertAction = .init(title: "update".localized.lowercased(), style: .default, handler: { [weak self] alert in
            
            DispatchQueue.main.async {
                self?.compiledContainerView.undim()
            }
            
            self?.bubble(BrowserEvents.CompiledModelCreationStatusUpdated.init(.update, stock: self?.model?.stock.asSearchStock))
        })
        
        let create: UIAlertAction = .init(title: "new model".localized.lowercased(), style: .destructive, handler: { [weak self] alert in
            
            DispatchQueue.main.async {
                self?.compiledContainerView.undim()
            }
            self?.bubble(BrowserEvents.CompiledModelCreationStatusUpdated.init(.step1, stock: self?.model?.stock.asSearchStock))
        })
        
        let cancel: UIAlertAction = .init(title: "cancel", style: .cancel, handler: { [weak self] alert in
            DispatchQueue.main.async {
                self?.compiledContainerView.undim()
            }
        })
        
        switch lifecycle {
        case .isStale:
            controller.addAction(create)
            controller.addAction(cancel)
            self.compiledContainerView.dim()
            bubble(HomeEvents.PresentAlertController.init(controller))
        case .needsSyncing:
            controller.addAction(train)
            controller.addAction(update)
            controller.addAction(cancel)
            self.compiledContainerView.dim()
            bubble(HomeEvents.PresentAlertController.init(controller))
        default: return
        }
        
        
    }
}

extension BrowserModelCell {
    func showViewForCreation() {
        updateAppearance(forHiddenViews: [compiledCreateDetailsContainerView, spacer], forAppearingViews: [compiledStackView])
    }
    
    func hideViewsForCreation() {
        guard !self.orientationIsIPhoneLandscape else { return }
        updateAppearance(forHiddenViews: [compiledStackView], forAppearingViews: [compiledCreateDetailsContainerView, spacer])
    }
    
    func showViewForLandscape() {
        if isCreating {
            updateAppearance(forHiddenViews: [compiledStackView], forAppearingViews: [compiledCreateDetailsContainerView, spacer])
        } else {
            updateAppearance(forHiddenViews: [compiledCreateDetailsContainerView, spacer], forAppearingViews: [compiledStackView])
        }
    }
    
    func hideViewsForLandscape() {
        updateAppearance(forHiddenViews: [compiledCreateDetailsContainerView, compiledStackView, spacer], forAppearingViews: [])
    }
    
    func updateAppearance(forHiddenViews hViews: [UIView], forAppearingViews aViews: [UIView]) {
        
        for view in hViews {
            view.layer.removeAllAnimations()
        }
        
        for view in aViews {
            view.layer.removeAllAnimations()
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            for view in hViews {
                view.alpha = 0.0
                view.isHidden = true
            }
            
            for view in aViews {
                view.alpha = 1.0
                view.isHidden = false
            }
        }, completion: { [weak self] finished in
            
            if self?.orientationIsIPhoneLandscape == true {
                self?.compiledCreateDetailsContainerView.isHidden = true
                self?.compiledLabel.isHidden = true
                self?.spacer.isHidden = true
            } else {
                for view in hViews {
                    view.alpha = 0.0
                    view.isHidden = true
                }
                
                for view in aViews {
                    view.alpha = 1.0
                    view.isHidden = false
                }
            }
        })
    }
}
