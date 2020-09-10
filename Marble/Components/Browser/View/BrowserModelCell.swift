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
    
    //Compiled Section's action label (CompiledActionStackView)
    lazy var compiledActionLabel: UILabel = {
        let label: UILabel = .init()
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.textAlignment = .left
        label.textColor = GlobalStyle.Colors.green
        return label
    }()
    
    
    //Compiled Section's action stack (left side)
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
        label.textAlignment = .left
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
        view.distribution = .fill
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
            case .step2:
                break
            default: showViewForCreation()
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
                compiledCreateDetailsContainerView
            ]
        )
        
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = GlobalStyle.largePadding
        view.setCustomSpacing(GlobalStyle.padding, after: standaloneLabel)
        
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
            if model?.data != nil {
                compiledTradingDayLabel.text = "test"
                compiledDaysLabel.text = "144"
                compiledModelsWithinLabel.text = "12"
                compiledActionLabel.text = "Action"
                compiledContainerStackView.isHidden = false
                compiledCreateLabel.isHidden = true
                compiledContainerView.backgroundColor = GlobalStyle.Colors.marbleBrown
            } else {
                compiledContainerStackView.isHidden = true
                compiledCreateLabel.isHidden = false
                compiledContainerView.backgroundColor = .clear
            }
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
                self.collection.view.reloadData()
            }
        }
    }
    
    lazy var maxDays: Int = {
        return PredictionRules.init().maxDays
    }()
    
    //MARK: Gestures
    private lazy var createTappedGesture: UITapGestureRecognizer = {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer
            .init(target: self,
                  action: #selector(self.createTapped(_:)))
        
        return gesture
    }()
    
    private lazy var cancelTappedGesture: UITapGestureRecognizer = {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer
            .init(target: self,
                  action: #selector(self.cancelTapped(_:)))
        
        return gesture
    }()
    
    private lazy var doneTappedGesture: UITapGestureRecognizer = {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer
            .init(target: self,
                  action: #selector(self.doneTapped(_:)))
        
        return gesture
    }()
    
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
            make.centerX
                .equalToSuperview()
                .offset(-1*(compiledCreationCancelLabel.frame.size.width/2 + GlobalStyle.spacing*4))
            make.centerY
                .equalToSuperview()
                .offset(compiledCreationStatusLabel.font.lineHeight/2 + GlobalStyle.spacing*2)
            make.width.equalTo(compiledCreationCancelLabel.frame.size.width + GlobalStyle.spacing*4)
            make.height.equalTo(compiledCreationCancelLabel.font.lineHeight + GlobalStyle.spacing*2)
        }
        compiledCreationDoneLabel.snp.makeConstraints { make in
            make.centerX
                .equalToSuperview()
                .offset(compiledCreationDoneLabel.frame.size.width/2 + GlobalStyle.spacing*4)
            make.centerY
                .equalToSuperview()
                .offset(compiledCreationStatusLabel.font.lineHeight/2 + GlobalStyle.spacing*2)
            make.width.equalTo(compiledCreationDoneLabel.frame.size.width + GlobalStyle.spacing*4)
            make.height.equalTo(compiledCreationDoneLabel.font.lineHeight + GlobalStyle.spacing*2)
        }
        compiledCreationCancelLabel.addGestureRecognizer(cancelTappedGesture)
        compiledCreationDoneLabel.addGestureRecognizer(doneTappedGesture)
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
        compiledTradingDayLabel.text = ""
        compiledDaysLabel.text = ""
        compiledModelsWithinLabel.text = ""
        compiledActionLabel.text = ""
        compiledContainerStackView.isHidden = true
        compiledCreateLabel.isHidden = true
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
    @objc func createTapped(_ sender: UITapGestureRecognizer) {
        bubble(BrowserEvents.CompiledModelCreationStatusUpdated.init(.step1))
    }
    
    @objc func cancelTapped(_ sender: UITapGestureRecognizer) {
        bubble(BrowserEvents.CompiledModelCreationStatusUpdated.init(.none))
    }
    
    @objc func doneTapped(_ sender: UITapGestureRecognizer) {
        switch currentCreationStatusStep {
        case .step1:
            guard compiledModelCreationData != nil else { return }
            bubble(BrowserEvents.CompiledModelCreationStatusUpdated.init(.step2))
        case .step2:
            bubble(BrowserEvents.CompiledModelCreationStatusUpdated.init(.step3))
        default:
            break
        }
    }
}

extension BrowserModelCell {
    func showViewForCreation() {
        updateAppearance(forHiddenViews: [compiledCreateDetailsContainerView], forAppearingViews: [compiledStackView])
    }
    
    func hideViewsForCreation() {
        updateAppearance(forHiddenViews: [compiledStackView], forAppearingViews: [compiledCreateDetailsContainerView])
    }
    
    func updateAppearance(forHiddenViews hViews: [UIView], forAppearingViews aViews: [UIView]) {
        UIView.animate(withDuration: 0.25, animations: {
            for view in hViews {
                view.alpha = 0.0
                view.isHidden = true
            }
            
            for view in aViews {
                view.alpha = 1.0
                view.isHidden = false
            }
        }, completion: { finished in
            
        })
    }
}
