//
//  ConsoleDetailView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/24/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

struct ConsoleDetailPayload {
    let currentTradingDay: String
    let historicalTradingData: [StockData]
    let stockSentimentData: [StockSentimentData]
    let days: Int
    let maxDays: Int
    let model: StockKitModels
}

class PredictWorkItem {
    let workItem: DispatchWorkItem
    init(_ workItem: DispatchWorkItem) {
        self.workItem = workItem
        
        DispatchQueue.init(
            label: "stoic.predicting").asyncAfter(
                deadline: .now() + 0.42,
                execute: workItem)
    }
    
    public func cancel() {
        workItem.cancel()
    }
    
    public func perform() {
        workItem.perform()
    }
}

class ConsoleDetailView: GraniteView {
    lazy var lineView: ConsoleDetailLineView = {
        return .init()
    }()
    
    lazy var modelPickerView: ConsoleDetailModelView = {
        return .init()
    }()
    
    lazy var headerView: ConsoleDetailHeaderView = {
        return .init()
    }()
    
    lazy var historicalView: ConsoleDetailHistoricalView = {
        return .init()
    }()
    
    lazy var sentimentView: ConsoleDetailSentimentView = {
        return .init()
    }()
    
    lazy var predictionView: ConsoleDetailPredictionView = {
        return .init(minified: true)
    }()
    
    lazy var disclaimerView: ConsoleDetailDisclaimerView = {
        return .init()
    }()
    
    var currentPredictionWorkItem: PredictWorkItem? = nil {
        didSet {
            oldValue?.cancel()
        }
    }
    
    lazy var loaderView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = GlobalStyle.Colors.purple.withAlphaComponent(0.36)
        
        view.isHidden = true
        
        return (view)
    }()
    
    let baseFrame: CGRect
    
    var baseSize: CGSize {
        return baseFrame.size
    }
    
    private var stockSymbol: String? = nil
    private var loader: ConsoleLoader?
    private var isThinking: Bool = false
    private var isOffline: Bool = false
    private var payload: ConsoleDetailPayload? = nil
    
    private var interactedWithPlot: Bool = false
    
    override init(frame: CGRect) {
        self.baseFrame = frame
        super.init(frame: frame)
        
        loader = .init(self, baseText: " /* thinking\(ConsoleLoader.seperator) */")
        
        addSubview(lineView)
        addSubview(modelPickerView)
//        addSubview(headerView)
        
        addSubview(sentimentView)
//        addSubview(disclaimerView)
        addSubview(predictionView)
//        addSubview(historicalView)
//        addSubview(loaderView)
//
//        headerView.snp.makeConstraints { make in
//            make.top.left.right.equalToSuperview()
//            make.height.equalTo(baseSize.height*0.12)
//        }
//
//        historicalView.snp.makeConstraints { make in
//            make.top.equalTo(headerView.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(baseSize.height*0.24)
//        }
//
        modelPickerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(GlobalStyle.Fonts.courier(.large, .bold).lineHeight + GlobalStyle.padding + GlobalStyle.padding/2)
            make.width.equalToSuperview().multipliedBy(0.36)
        }
        
        sentimentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(baseSize.height*0.2 + GlobalStyle.padding)
        }
//
        predictionView.snp.makeConstraints { make in
            make.bottom.equalTo(sentimentView.snp.top).offset(-GlobalStyle.padding)
            make.centerX.equalToSuperview()
            make.size.equalTo(baseSize.height*0.12)
        }
//
//        disclaimerView.snp.makeConstraints { make in
//            make.top.equalTo(predictionView.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(baseSize.height*0.16)
//        }
//
//        loaderView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        lineView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(sentimentView.snp.top).offset(-GlobalStyle.padding)
        }
        
        modelPickerView.delegate = self
        predictionView.delegate = self
        sentimentView.delegate = self
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(_ payload: ConsoleDetailPayload) {
        thinkingStopped()
        
        stockSymbol = "$"+(payload.historicalTradingData.first?.symbolName ?? "")
        headerView.updateTradingDay(payload.currentTradingDay)
        
        modelPickerView.updateData(payload.model)
        
        historicalView.updateData(
            payload.historicalTradingData.reversed(),
            payload.stockSentimentData)
        
        lineView.updateData(payload)
        
        predictionView.updateModel(
            model: payload.model,
            stockData: payload.historicalTradingData)
        
        self.payload = payload
    }
    
    
    func updateThink(_ payload: ThinkPayload?) {
        thinkingStopped()
        
        guard let newPayload = payload?.payload else {
            return
        }
        
        updateData(newPayload)
//        if let sentiment = payload?.stockSentimentData {
//            sentimentView.updateSlider(sentiment)
//
//            sentimentChanged(
//                sentiment.posAverage,
//                negative: sentiment.negAverage,
//                neutral: sentiment.neuAverage,
//                compound: sentiment.compoundAverage)
//        }
    }
    
    func updatePage(_ component: RobinhoodPage.PageComponent) {
        lineView.updatePage(component)
    }
    
    override func hitTest(
        _ point: CGPoint,
        with event: UIEvent?) -> UIView? {
        
        let historicalFrame = modelPickerView.frame
        let historicalTableViewFrame = modelPickerView.modelPicker.frame
        let historicalIndicator = modelPickerView.indicatorContainer.frame
        
        let adjHistoricalTableViewFrame: CGRect = .init(
            origin: historicalFrame.origin,
            size: .init(width: historicalTableViewFrame.width + historicalTableViewFrame.origin.x,
                        height: historicalTableViewFrame.height + historicalTableViewFrame.origin.y))
        
        let adjHistoricalIndicatorFrame: CGRect = .init(
            origin: historicalFrame.origin,
            size: .init(width: historicalIndicator.width + historicalIndicator.origin.x,
                        height: historicalIndicator.height + historicalIndicator.origin.y))

        if  adjHistoricalTableViewFrame.contains(point),
            modelPickerView.expand,
            !adjHistoricalIndicatorFrame.contains(point) {
            
            return modelPickerView.modelPicker
        } else {
            return super.hitTest(point, with: event)
        }
    }
}

extension ConsoleDetailView: ConsoleDetailModelViewDelegate {
    func updateModel(_ type: StockKitModels.ModelType) {
        guard let mutablePayload = self.payload else { return }
        mutablePayload.model.currentType = type
        updateData(mutablePayload)
    }
}

extension ConsoleDetailView: ConsoleLoaderDelegate {
    public func consoleLoaderUpdated(_ indicator: String) {
        if let consoleView = superview as? ConsoleView, let symbol = stockSymbol {
            consoleView.tickerLabel.text = symbol+indicator
        }
    }
}

extension ConsoleDetailView {
    public func didInteractWithPlot(active: Bool) {
        if active && self.modelPickerView.alpha == 1.0 {
            UIView.animate(
                withDuration: 0.12,
                animations: {
                    self.modelPickerView.alpha = 0
            })
        } else if !active {
            UIView.animate(
                withDuration: 0.12,
                animations: {
                    self.modelPickerView.alpha = 1.0
            })
        }
    }
}

extension ConsoleDetailView: ConsoleDetailSentimentViewDelegate {
    func sentimentChanged(
        _ positive: Double,
        negative: Double,
        neutral: Double,
        compound: Double) {
        
        currentPredictionWorkItem = .init(
            DispatchWorkItem.init(
                block: {
                    
            self.predictionView.predict(
                positive: positive,
                negative: negative,
                neutral: neutral,
                compound: compound)
        }))
    }
}

extension ConsoleDetailView: ConsoleDetailPredictionViewDelegate {
    func minimized() {
        self.loader?.stop()
        self.loader = .init(self)
        
        guard isThinking else { return }
        if let consoleView = superview as? ConsoleView {
            consoleView.tickerLabel.text = (stockSymbol ?? "")+(self.loader?.defaultStatus ?? "")
        }
        self.loader?.begin()
    }
    
    func expand() {
        self.loader?.stop()
        self.loader = .init(self, baseText: " /* thinking\(ConsoleLoader.seperator) */")
        
        guard isThinking else { return }
        if let consoleView = superview as? ConsoleView {
            consoleView.tickerLabel.text = (stockSymbol ?? "")+(self.loader?.defaultStatus ?? "")
        }
        self.loader?.begin()
    }
    
    func updateIsOfflineAppearance(_ isOffline: Bool, force: Bool = false) {
        self.isOffline = isOffline
        if (isOffline && self.loader?.isLoading == true && self.isThinking) || force {
            self.loader?.stop()
            
            if let consoleView = superview as? ConsoleView {
                consoleView.tickerLabel.text = (stockSymbol ?? "")+" /* OFFLINE */"
                consoleView.tickerLabel.textColor = GlobalStyle.Colors.red
                
            }
            self.predictionView.stopAnimation()
            self.loaderView.isHidden = true
        } else if self.isThinking || force {
            if self.loader?.isLoading == false {
                self.loaderView.isHidden = false
                if let consoleView = superview as? ConsoleView {
                    
                    consoleView.tickerLabel.text = (stockSymbol ?? "")+(self.loader?.defaultStatus ?? "")

                    consoleView.tickerLabel.textColor = GlobalStyle.Colors.purple
                }
                self.loader?.begin()
            }
        }
    }
    
    func thinking() {
        guard !isOffline else {
            updateIsOfflineAppearance(isOffline, force: true)
            return
        }
        
        self.loader?.begin()
        self.loaderView.isHidden = false
        
        if let consoleView = superview as? ConsoleView {
            consoleView.tickerLabel.textColor = GlobalStyle.Colors.purple
            consoleView.tickerLabel.text = (stockSymbol ?? "")+(self.loader?.defaultStatus ?? "")
        }
        
        isThinking = true
    }
    
    func thinkingStopped() {
        self.loader?.stop()
        self.loaderView.isHidden = true
        
        if let consoleView = superview as? ConsoleView, let symbol = stockSymbol {
            consoleView.tickerLabel.text = symbol
            consoleView.tickerLabel.textColor = GlobalStyle.Colors.black
        }
        
        isThinking = false
    }
    
    func predictionUpdate(_ output: Double) {
        lineView.predictionUpdate(output)
    }
}
