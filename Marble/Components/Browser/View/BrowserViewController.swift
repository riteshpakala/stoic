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
    
    private lazy var engineVersionGesture: UITapGestureRecognizer = {
        .init(target: self, action: #selector(engineVersionTapped))
    }()
    
    override public func loadView() {
        self.view = BrowserView.init()
    }
    
    public var _view: BrowserView {
        return self.view as! BrowserView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        _view.predictionEngineVersion.addGestureRecognizer(engineVersionGesture)
        
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
        
        
        if self.isIPhone {
            browserModelCell.layoutIfNeeded()
        }
        
        guard object.model != nil else { return browserModelCell }
        
        if let stockKit = component?.getSubComponent(StockKitComponent.self) as? StockKitComponent,
            let nextValidTradingDay = component?.state.nextValidTradingDay {
            let maxDays = stockKit.state.rules.maxDays
            let components = Calendar.nyCalendar.dateComponents([.day], from: nextValidTradingDay.asDate() ?? Date(), to: object.date ?? Date())
            
            let dayDiff = abs(components.day ?? maxDays)
            browserModelCell.lifecycle = (dayDiff >= maxDays) ? .isStale : (dayDiff > 0 ? .needsSyncing : .isReady)
        }
        
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
        
        if dataSource?.controller.fetchedObjects == nil {
            dataSource?.performFetch()
        } else {
            _view.collection.layout.invalidateLayout()
        }
    }
    
    override public func bind(_ component: Component<BrowserState>) {
        super.bind(component)
        
        if component.state.mergedModels.isEmpty {
            _view.setupEmptyView()
        }
        
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
        
        observeState(
            \.isCompiling,
            handler: observeIsCompiling(_:),
            async: .main)
    }
    
    @objc
    func engineVersionTapped(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        
        component?.push(
            AnnouncementBuilder.build(
                component!.service,
                state: .init(
                    displayType: .alert(component?.state.mergedModels.first?.engine ?? "unknown engine version"))),
            display: .modal)
    }
}

extension BrowserViewController {
    func observeTradingDay(_ day: Change<String>) {
        
        guard component?.service.center.isOnline == true else {
            _view.isOffline = true
            return
        }
        
        _view.updateTradingLabel("trading day".localized+": "+(day.newValue ?? "unknown"))
        
        if day.newValue != nil {
            _view.collection.view.reloadData()
            _view.undim()
        }
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
        guard component?.state.currentCompiledStatus == .step2 || component?.state.currentCompiledStatus == .update else { return }
        print("{Browser} observed data model change")
        for cell in _view.collection.view.visibleCells {
            if let dataCell = cell as? BrowserModelCell {
                dataCell.compiledModelCreationData = component?.state.compiledModelCreationData
            }
        }
    }
    
    func observeIsCompiling(_ data: Change<Bool>) {        if data.newValue == true {
            _view.compile()
        } else {
            _view.compileFinished()
        }
    }
}

extension BrowserViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let size: CGSize
        let hasMore: Bool = (dataSource?.controller.fetchedObjects?.count ?? 0 ) > 1
        
        if hasMore {
            if self.orientation.isLandscape {
                size = .init(
                    width: min(collectionView.frame.size.width, collectionView.frame.size.height)*(self.isIPad ? 1 : 2),
                    height: collectionView.frame.size.height)
            } else {
                size = .init(
                    width: min(collectionView.frame.size.width, collectionView.frame.size.height),
                    height: collectionView.frame.size.height)
            }
        } else {
            size = collectionView.frame.size
        }
        
        return size
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
    
    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
        
        guard let browserModelCell = cell as? BrowserModelCell else { return }
        
        if self.orientationIsIPhoneLandscape {
            browserModelCell.hideViewsForLandscape()
            browserModelCell.layoutIfNeeded()
        } else if self.orientationIsIPhonePortrait {
            browserModelCell.showViewForLandscape()
            browserModelCell.layoutIfNeeded()
        }
        
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
