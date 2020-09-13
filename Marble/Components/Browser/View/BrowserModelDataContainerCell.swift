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

public class BrowserModelDataContainerCell: UICollectionViewCell {
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
        view.isPagingEnabled = false
        view.decelerationRate = UIScrollView.DecelerationRate.fast
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
    
    var baseSelectedModel: IndexPath? = nil
    var selectedModel: IndexPath? = nil
    var inCompatibleModels: [StockModel] = []
    
    var currentCreationStatusStep: BrowserCompiledModelCreationStatus = .none {
        didSet {
            guard oldValue != currentCreationStatusStep else { return }
            
            
            if currentCreationStatusStep == .none {

                for cell in self.collection.view.visibleCells {
                    if let dataCell = cell as? BrowserModelDataCell {
                        dataCell.status = BrowserModelDataCell.BrowserModelStatus.none
                    }
                }
                
                var indexPathsToReload: [IndexPath] = []
                if let oldBaseModelIndexPath = baseSelectedModel {
                    baseSelectedModel = nil
                    indexPathsToReload.append(oldBaseModelIndexPath)
                }
                
                if let oldSelectedModelIndexPath = selectedModel {
                    selectedModel = nil
                    indexPathsToReload.append(oldSelectedModelIndexPath)
                }
                
                
                for modelToRemove in self.inCompatibleModels {
                    if let index = self.models?.firstIndex(where: { $0.id == modelToRemove.id }) {
                        
                        indexPathsToReload.append(.init(item: index, section: 0))
                    }
                }
                self.inCompatibleModels = []
                
                self.collection.view.reloadItems(at: indexPathsToReload)
                    
            } else if currentCreationStatusStep == .step1 {
                for cell in self.collection.view.visibleCells {
                    if let dataCell = cell as? BrowserModelDataCell {
                        dataCell.status = .compatible
                    }
                }
            }
        }
    }
    var compiledModelCreationData: BrowserCompiledModelCreationData? = nil {
        didSet {
            var updateCompatibility: Bool = false
            var indexPathsToUpdate: [IndexPath] = []
            switch currentCreationStatusStep {
            case .step1:
                let oldBaseModelIndexPath: IndexPath? = baseSelectedModel
                
                if models?.firstIndex(where: { $0.id == compiledModelCreationData?.baseModel.id }) != nil {
                    baseSelectedModel = compiledModelCreationData?.baseModelIndexPath
                } else {
                    baseSelectedModel = nil
                }
                
                if let selectedIndexPath = baseSelectedModel {
                    if let baseIndexPath = oldBaseModelIndexPath {
                        
                        indexPathsToUpdate.append(contentsOf: [baseIndexPath, selectedIndexPath])
                    } else {
                        indexPathsToUpdate.append(selectedIndexPath)
                    }
                } else if let baseIndexPath = oldBaseModelIndexPath {
                    indexPathsToUpdate.append(baseIndexPath)
                }
                updateCompatibility = true
            case .step2:
                guard let modelDay = self.models?.first?.tradingDay,
                    baseSelectedModel == nil else { return }
                
                let idsOfModels: [String] = self.models?.compactMap({ $0.id }) ?? []
                
                if  let baseModelID = compiledModelCreationData?.baseModel.id,
                    !idsOfModels.contains(baseModelID) {
                    
                    if let selectedModelIndex = compiledModelCreationData?.modelsToMerge[modelDay]?.indexPath {
                        
                        let oldSelectedModelIndexPath = selectedModel
                        selectedModel = selectedModelIndex
                        if let oldSelectedModel = oldSelectedModelIndexPath {

                            indexPathsToUpdate.append(contentsOf: [oldSelectedModel, selectedModelIndex])
                        } else if selectedModel != oldSelectedModelIndexPath {
                            indexPathsToUpdate.append(selectedModelIndex)
                        }
                    } else if let oldSelectedModelIndexPath = selectedModel {
                        selectedModel = nil
                        indexPathsToUpdate.append(oldSelectedModelIndexPath)
                    }
                }
                updateCompatibility = true
            default: break
            }
            
            if  updateCompatibility,
                let compatible = compiledModelCreationData?.compatibleModels {
                
                let compatibleIds = compatible.map { $0.id }
                
                let inCompatible = self.models?.filter { !compatibleIds.contains($0.id) } ?? []

                //Indices for new models that are incompatible
                for modelToRemove in inCompatible {
                    
                    if let index = self.models?.firstIndex(where: {
                        $0.id == modelToRemove.id &&
                            !self.inCompatibleModels.contains($0) }) {
                        
                        indexPathsToUpdate.append(.init(item: index, section: 0))
                        
                    }
                }
                
                //Indices for old models that are now compatible
                for modelToRemove in self.inCompatibleModels {
                    if let index = self.models?.firstIndex(where: { compatibleIds.contains(modelToRemove.id) && $0.id == modelToRemove.id }) {
                        
                        indexPathsToUpdate.append(.init(item: index, section: 0))
                    }
                }
                
                self.inCompatibleModels = inCompatible
            } else if currentCreationStatusStep != .none {
                for modelToRemove in self.inCompatibleModels {
                    if let index = self.models?.firstIndex(where: { $0.id == modelToRemove.id }) {
                        
                        indexPathsToUpdate.append(.init(item: index, section: 0))
                    }
                }
                self.inCompatibleModels = []
            }
            
            
            guard !indexPathsToUpdate.isEmpty else { return }
            
            self.collection.view.reloadItems(at: indexPathsToUpdate.removingDuplicates())
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        collection.layout.invalidateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        models = nil
    }
}

extension BrowserModelDataContainerCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
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
            if let baseModelIndexPath = baseSelectedModel,
                indexPath == baseModelIndexPath {
                dataCell.status = .baseModel
            } else if selectedModel == indexPath {
                dataCell.status = .appendedModel
            } else if inCompatibleModels.contains(models[indexPath.item]) {
                dataCell.status = .inCompatible
            } else if self.currentCreationStatusStep != .none {
                dataCell.status = .compatible
            } else {
                dataCell.status = BrowserModelDataCell.BrowserModelStatus.none
            }
            
            dataCell.currentCreationStatusStep = self.currentCreationStatusStep
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
        
        guard let dataCell = collectionView
            .cellForItem(at: indexPath) as? BrowserModelDataCell,
              let model = dataCell.model else {

            return
        }
        
        guard currentCreationStatusStep != .none else {
            bubble(BrowserEvents.StandaloneModelSelected.init(model, indexPath: indexPath))
            return
        }
        
        switch currentCreationStatusStep {
        case .step1:
            bubble(BrowserEvents.BaseModelSelected.init(model, indexPath: indexPath))
        case .step2:
            guard dataCell.modelIsAvailableForSelection else { return }
            bubble(BrowserEvents.ModelToMerge.init(model, indexPath: indexPath))
        default:
            break
        }
    }
}

extension BrowserModelDataContainerCell: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collection.view.scrollToNearestVisibleCollectionViewCell()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.collection.view.scrollToNearestVisibleCollectionViewCell()
    }
}
