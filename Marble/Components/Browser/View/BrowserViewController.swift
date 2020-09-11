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
        
        observeState(
            \.nextValidTradingDay,
            handler: observeTradingDay(_:),
            async: .main)
        
        observeState(
            \.currentCompiledCreationStatus,
            handler: observeCompiledCreationStatus(_:),
            async: .main)
        
        observeState(
            \.compiledModelCreationData,
            handler: observeCompiledCreationData(_:),
            async: .main)
        
        observeState(
            \.compiledModelCreationData?.modelsToMerge,
            handler: observeCompiledMergeData(_:),
            async: .main)
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
        
        browserModelCell.model = object
        browserModelCell.currentCreationStatusStep = component?.state.currentCompiledStatus ?? .none
        browserModelCell.compiledModelCreationData = component?.state.compiledModelCreationData
        return browserModelCell
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dataSource?.performFetch()
    }
    
    override public func bind(_ component: Component<BrowserState>) {
        super.bind(component)
        
        if component.state.mergedModels.isEmpty {
            _view.setupEmptyView()
        }
    }
}

extension BrowserViewController {
    func observeTradingDay(_ day: Change<String>) {
        
        _view.nextTradingDayLabel.text = "trading day".localized+": "+(day.newValue ?? "unknown")
    }
    
    func observeCompiledCreationStatus(_ status: Change<String>) {
        guard let currentStep = component?.state.currentCompiledStatus else { return }
        
        _view.collection.view.isScrollEnabled = currentStep == .none
        
        for cell in _view.collection.view.visibleCells {
            if let dataCell = cell as? BrowserModelCell {
                dataCell.currentCreationStatusStep = currentStep
            }
        }
    }
    
    func observeCompiledCreationData(_ data: Change<BrowserCompiledModelCreationData?>) {
        print("{Browser} observed data change \(CFAbsoluteTimeGetCurrent())")
        for cell in _view.collection.view.visibleCells {
            if let dataCell = cell as? BrowserModelCell {
                dataCell.compiledModelCreationData = component?.state.compiledModelCreationData
            }
        }
    }
    
    func observeCompiledMergeData(_ data: Change<[String: BrowserCompiledModelCreationData.CompiledMergeModelData]?>) {
        guard component?.state.currentCompiledStatus == .step2 else { return }
        print("{Browser} observed data model change")
        for cell in _view.collection.view.visibleCells {
            if let dataCell = cell as? BrowserModelCell {
                dataCell.compiledModelCreationData = component?.state.compiledModelCreationData
            }
        }
    }
}

extension BrowserViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        return  .init(
            width: collectionView.frame.size.width,
            height: collectionView.frame.size.height)
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

extension BrowserViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        _view.collection.view.scrollToNearestVisibleCollectionViewCell()
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        _view.collection.view.scrollToNearestVisibleCollectionViewCell()
    }
}

extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
