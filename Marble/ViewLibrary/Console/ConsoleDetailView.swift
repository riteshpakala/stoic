//
//  ConsoleDetailView.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/24/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

struct ConsoleDetailPayload {
    let currentTradingDay: String
    let historicalTradingData: [StockData]
    let stockSentimentData: [StockSentimentData]
    let days: Int
    let maxDays: Int
    let model: StockKitUtils.Models
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

class ConsoleDetailView: UIView {
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
        return .init()
    }()
    
    lazy var disclaimerView: ConsoleDetailDisclaimerView = {
        return .init()
    }()
    
    var currentPredictionWorkItem: PredictWorkItem? = nil {
        didSet {
            oldValue?.cancel()
        }
    }
    
    let baseFrame: CGRect
    
    var baseSize: CGSize {
        return baseFrame.size
    }
    
    override init(frame: CGRect) {
        self.baseFrame = frame
        super.init(frame: frame)
        
        addSubview(headerView)
        addSubview(sentimentView)
        addSubview(disclaimerView)
        addSubview(predictionView)
        addSubview(historicalView)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(baseSize.height*0.12)
        }
        
        historicalView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(baseSize.height*0.22)
        }
        
        sentimentView.snp.makeConstraints { make in
            make.top.equalTo(historicalView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(baseSize.height*0.22)
        }
        
        predictionView.snp.makeConstraints { make in
            make.top.equalTo(sentimentView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(baseSize.height*0.22)
        }
        
        disclaimerView.snp.makeConstraints { make in
            make.top.equalTo(predictionView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(baseSize.height*0.22)
        }
        
        sentimentView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(_ payload: ConsoleDetailPayload) {
        
        headerView.updateTradingDay(payload.currentTradingDay)
        historicalView.updateData(
            payload.historicalTradingData.reversed(),
            payload.stockSentimentData)
        
        predictionView.updateModel(
            payload.days,
            maxDays: payload.maxDays,
            model: payload.model,
            stockData: payload.historicalTradingData)
    }
    
    override func hitTest(
        _ point: CGPoint,
        with event: UIEvent?) -> UIView? {
        
        let historicalFrame = historicalView.frame
        let historicalTableViewFrame = historicalView.historicDatePicker.frame
        let historicalIndicator = historicalView.indicator.frame
        
        let adjHistoricalTableViewFrame: CGRect = .init(
            origin: historicalFrame.origin,
            size: .init(width: historicalTableViewFrame.width + historicalTableViewFrame.origin.x,
                        height: historicalTableViewFrame.height + historicalTableViewFrame.origin.y))
        
        let adjHistoricalIndicatorFrame: CGRect = .init(
            origin: historicalFrame.origin,
            size: .init(width: historicalIndicator.width + historicalIndicator.origin.x,
                        height: historicalIndicator.height + historicalIndicator.origin.y))
        
        let predictionFrame = predictionView.frame
        let predictionTableViewFrame = predictionView.predictionRangePicker.frame
        let predictionIndicator = predictionView.indicator.frame
        
        let adjPredictionTableViewFrame: CGRect = .init(
            origin: predictionFrame.origin,
            size: .init(width: predictionTableViewFrame.width + predictionTableViewFrame.origin.x,
                        height: predictionTableViewFrame.height + predictionTableViewFrame.origin.y))
        let adjPredictionIndicatorFrame: CGRect = .init(
            origin: predictionFrame.origin,
            size: .init(width: predictionIndicator.width + predictionIndicator.origin.x,
                        height: predictionIndicator.height + predictionIndicator.origin.y))
        
        if  adjHistoricalTableViewFrame.contains(point),
            historicalView.expand,
            !adjHistoricalIndicatorFrame.contains(point) {
            
            return historicalView.historicDatePicker
        } else if adjPredictionTableViewFrame.contains(point),
                  predictionView.expand,
                  !adjPredictionIndicatorFrame.contains(point) {
            return predictionView.predictionRangePicker
        } else {
            return super.hitTest(point, with: event)
        }
    }
}

extension ConsoleDetailView: ConsoleDetailSentimentViewDelegate {
    func sentimentChanged(_ positive: Double, negative: Double, neutral: Double) {
        currentPredictionWorkItem = .init(
            DispatchWorkItem.init(
                block: {
                    
            self.predictionView.predict(
                positive: positive,
                negative: negative,
                neutral: neutral)
        }))
    }
}

//MARK: Header
class ConsoleDetailHeaderView: UIView {
    let currentTradingDay: UILabel = {
        let label: UILabel = .init()
        label.text = ""
        label.textColor = GlobalStyle.Colors.green
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.textAlignment = .left
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        addSubview(currentTradingDay)
        currentTradingDay.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTradingDay(_ date: String) {
        currentTradingDay.text = "trading day: "+date
    }
}

//MARK: Historical
class ConsoleDetailHistoricalView: UIView {
    lazy var historicDatePicker: StockDatePicker = {
        return .init(color: GlobalStyle.Colors.green)
    }()
    
    lazy var indicator: TriangleView = {
        return .init(
            frame: .zero,
            color: GlobalStyle.Colors.green)
    }()
    
    var expand: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.expand {
                    self.historicDatePicker.snp.remakeConstraints { make in
                        make.left.equalToSuperview().offset(GlobalStyle.padding)
                        make.width.equalToSuperview().multipliedBy(0.48)
                        make.height.equalTo(self.cellsToViewWhenExpanded * self.historicDatePicker.cellHeight)
                        make.top.equalToSuperview().offset(self.historicDatePicker.frame.origin.y)
                    }
                } else {
                    self.historicDatePicker.snp.remakeConstraints { make in
                        make.left.equalToSuperview().offset(GlobalStyle.padding)
                        make.width.equalToSuperview().multipliedBy(0.48)
                        make.height.equalToSuperview().multipliedBy(0.66)
                        make.centerY.equalToSuperview()
                    }
                }
            }
        }
    }
    
    lazy var emotionLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.green
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.text = "+: 50%\n-: 50%"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var openLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.green
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 0
        label.text = "open: $0000.00\nclose: $0000.00"
        return label
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView.init(arrangedSubviews: [emotionLabel, openLabel])
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var tapGestureTableView: UITapGestureRecognizer = {
        return .init(target: self, action: #selector(self.tapRegistered(_:)))
    }()
    
    var cellHeight: CGFloat {
        didSet {
            historicDatePicker.cellHeight = cellHeight
        }
    }
    var cellsToViewWhenExpanded: CGFloat
    
    private var stockData: [StockData]? = nil
    private var sentimentStockData: [StockSentimentData]? = nil
    private var currentIndex: Int = 0
    init(
        cellHeight: CGFloat = 30,
        cellsToViewWhenExpanded: CGFloat = 3) {
        self.cellHeight = cellHeight
        self.cellsToViewWhenExpanded = cellsToViewWhenExpanded
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        historicDatePicker.cellHeight = cellHeight
        
        addSubview(historicDatePicker)
        addSubview(indicator)
        addSubview(hStack)
        
        self.historicDatePicker.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.width.equalToSuperview().multipliedBy(0.48)
            make.height.equalToSuperview().multipliedBy(0.66)
            make.centerY.equalToSuperview()
        }
        
        self.indicator.snp.makeConstraints { make in
            make.right.equalTo(historicDatePicker.snp.right).offset(-GlobalStyle.padding)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.19)
            make.width.equalTo(indicator.snp.height).multipliedBy(1.3)
        }
        
        self.hStack.snp.makeConstraints { make in
            make.left.equalTo(historicDatePicker.snp.right).offset(GlobalStyle.spacing)
            make.right.equalToSuperview().offset(-GlobalStyle.spacing)
            make.top.bottom.equalToSuperview()
        }
        
        indicator.addGestureRecognizer(tapGestureTableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateData(_ data: [StockData], _ sentimentData: [StockSentimentData]) {
        cellHeight = self.frame.height*0.66
            
        historicDatePicker.data = data
        
        stockData = data
        sentimentStockData = sentimentData
        
        updateStats(currentIndex)
    }
    
    public func updateStats(_ index: Int) {
        guard
            let data = stockData,
            let sentimentData = sentimentStockData,
            index < data.count else {
                openLabel.text = "⚠️"
                emotionLabel.text = "⚠️"
                return
        }
        
        let stock = data[index]
        openLabel.text = "open: $\(round(stock.open*100)/100)\nclose: $\(round(stock.close*100)/100)"
        
        guard let sentiment = sentimentData.first(
            where: { $0.dateAsString == stock.dateData.asString }) else {
            
                emotionLabel.text = "⚠️"
                return
        }
        
        emotionLabel.text = "+: \(Int(sentiment.posAverage*100))%\n-: \(Int(sentiment.negAverage*100))%"
    }
    
    @objc
    func tapRegistered(_ sender: UITapGestureRecognizer) {
        expand.toggle()
        indicator.rotate()
        
    }
}

//MARK: Sentiment
protocol ConsoleDetailSentimentViewDelegate: class {
    func sentimentChanged(_ positive: Double, negative: Double, neutral: Double)
}
class ConsoleDetailSentimentView: UIView {
    weak var delegate: ConsoleDetailSentimentViewDelegate?
    
    lazy var refineSlider: UISlider = {
        let view: UISlider = .init(frame: .zero)
        view.tintColor = GlobalStyle.Colors.orange
        view.setValue(0.0, animated: false)
        view.addTarget(self, action: #selector(self.sliderValue(_:)), for: .valueChanged)
        return view
    }()
    
    lazy var slider: UISlider = {
        let view: UISlider = .init(frame: .zero)
        view.tintColor = GlobalStyle.Colors.orange
        view.setValue(0.5, animated: false)
        view.addTarget(self, action: #selector(self.sliderValue(_:)), for: .valueChanged)
        return view
    }()
    
    lazy var seperator: UIView = {
        let label = UIView.init()
        label.backgroundColor = GlobalStyle.Colors.orange
        return label
    }()
    
    lazy var posLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.text = "[50%]"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var negLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.text = "[50%]"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var emotionLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 1
        label.text = "neutral"
        label.isHidden = true
        return label
    }()
    
    lazy var refineLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 1
        label.text = "λ"
        label.isHidden = true
        return label
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView.init(
            arrangedSubviews: [
                refineSlider,
                seperator,
                negLabel,
                slider,
                posLabel])
        stack.alignment = .center
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.setCustomSpacing(GlobalStyle.padding, after: refineSlider)
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        addSubview(hStack)
        addSubview(emotionLabel)
        addSubview(refineLabel)
        
        hStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        refineSlider.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        seperator.snp.makeConstraints { make in
            make.width.equalTo(GlobalStyle.spacing/2)
            make.height.equalToSuperview().multipliedBy(0.75)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sliderValue(
        _ slider: UISlider) {
        let neuValue = self.refineSlider.value
        var posValue = self.slider.value
        var negValue = abs(self.slider.value - 1.0)
        
        let diff = abs(1.0 - (posValue + negValue + neuValue))
        posValue -= diff/2
        negValue -= diff/2
        posValue = posValue < 0 ? 0 : posValue
        negValue = negValue < 0 ? 0 : negValue
        
        let posPercent = Int(posValue*100)
        let negPercent = Int(negValue*100)
        posLabel.text = "[\(posPercent)%]"
        negLabel.text = "[\(negPercent)%]"
        emotionLabel.text = "\(posPercent > negPercent ? "positive" : (posPercent < negPercent ? "negative" : "neutral"))"
        updateEmotionTrack()
        
        delegate?.sentimentChanged(
            Double(posValue),
            negative: Double(negValue),
            neutral: Double(neuValue))
    }
    
    func updateEmotionTrack() {
        emotionLabel.isHidden = false
        refineLabel.isHidden = false
        
        emotionLabel.sizeToFit()
        emotionLabel.center = .init(
            x: slider.thumbCenterX + GlobalStyle.padding,
            y: hStack.frame.maxY)
        
        refineLabel.sizeToFit()
        refineLabel.center = .init(
            x: refineSlider.thumbCenterX + GlobalStyle.padding,
            y: hStack.frame.maxY)
    }
}
extension UISlider {
    var thumbCenterX: CGFloat {
        let trackRect = self.trackRect(forBounds: frame)
        let thumbRect = self.thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
        return thumbRect.midX
    }
}

//MARK: Prediction
class ConsoleDetailPredictionView: UIView {
    lazy var predictionRangePicker: DaysPicker = {
        return .init(color: GlobalStyle.Colors.purple)
    }()
    
    lazy var indicator: TriangleView = {
        return .init(
            frame: .zero,
            color: GlobalStyle.Colors.purple)
    }()
    
    lazy var refetchTriggerContainer: UIView = {
        return .init()
    }()
    
    lazy var reFetchTrigger: UIImageView = {
        let view = UIImageView.init()
        view.image = UIImage(named:"console.detail.refresh")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var predictionLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.purple
        label.font = GlobalStyle.Fonts.courier(.subMedium, .bold)
        label.text = "open: $0000.00\nclose: $0000.00"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView.init(arrangedSubviews: [refetchTriggerContainer, predictionLabel])
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.spacing = GlobalStyle.spacing
        return stack
    }()
    
    lazy var tapGestureTableView: UITapGestureRecognizer = {
        return .init(target: self, action: #selector(self.tapRegistered(_:)))
    }()
    
    var cellsToViewWhenExpanded: CGFloat
    
    var expand: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.expand {
                    self.predictionRangePicker.snp.remakeConstraints { make in
                        make.left.equalToSuperview().offset(GlobalStyle.padding)
                        make.width.equalToSuperview().multipliedBy(0.39)
                        make.height.equalTo(self.cellsToViewWhenExpanded * self.predictionRangePicker.cellHeight)
                        make.top.equalToSuperview().offset(self.predictionRangePicker.frame.origin.y)
                    }
                } else {
                    self.predictionRangePicker.snp.remakeConstraints { make in
                        make.left.equalToSuperview().offset(GlobalStyle.padding)
                        make.width.equalToSuperview().multipliedBy(0.39)
                        make.height.equalToSuperview().multipliedBy(0.66)
                        make.centerY.equalToSuperview()
                    }
                }
            }
        }
    }
    
    var cellHeight: CGFloat {
        didSet {
            predictionRangePicker.cellHeight = cellHeight
        }
    }
    
    var days: Int = 0
    var maxDays: Int = 0 {
        didSet {
            predictionRangePicker.days = maxDays
        }
    }
    
    private var model: StockKitUtils.Models? = nil
    private var stockData: [StockData]? = nil
    
    init(cellHeight: CGFloat = 30,
        cellsToViewWhenExpanded: CGFloat = 3) {
        self.cellHeight = cellHeight
        self.cellsToViewWhenExpanded = cellsToViewWhenExpanded
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        predictionRangePicker.cellHeight = cellHeight
        
        addSubview(predictionRangePicker)
        addSubview(indicator)
        addSubview(hStack)
        
        self.predictionRangePicker.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.width.equalToSuperview().multipliedBy(0.39)
            make.height.equalToSuperview().multipliedBy(0.66)
            make.centerY.equalToSuperview()
        }
        
        self.indicator.snp.makeConstraints { make in
            make.right.equalTo(predictionRangePicker.snp.right).offset(-GlobalStyle.padding)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.19)
            make.width.equalTo(indicator.snp.height).multipliedBy(1.3)
        }
        
        self.hStack.snp.makeConstraints { make in
            make.left.equalTo(predictionRangePicker.snp.right).offset(GlobalStyle.spacing)
            make.right.equalToSuperview().offset(-GlobalStyle.spacing)
            make.top.bottom.equalToSuperview()
        }
        
        self.refetchTriggerContainer.snp.makeConstraints { make in
            make.height.width.equalTo(cellHeight)
        }
        
        refetchTriggerContainer.addSubview(reFetchTrigger)
        
        self.reFetchTrigger.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(GlobalStyle.spacing)
            make.right.bottom.equalToSuperview().offset(-GlobalStyle.spacing)
        }
        
        indicator.addGestureRecognizer(tapGestureTableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func tapRegistered(_ sender: UITapGestureRecognizer) {
        expand.toggle()
        indicator.rotate()
        
    }
    
    func updateModel(
        _ days: Int,
        maxDays: Int,
        model: StockKitUtils.Models,
        stockData: [StockData]) {
        
        cellHeight = self.frame.height*0.66
        self.days = days
        self.maxDays = maxDays
        self.model = model
        self.stockData = stockData
        predict()
    }
    
    public func predict(
        positive: Double = 0.5,
        negative: Double = 0.5,
        neutral: Double = 0.0) {
        
        guard let recentStock = self.stockData?.sorted(
            by: {
                ($0.dateData.asDate ?? Date())
                    .compare(($1.dateData.asDate ?? Date())) == .orderedDescending
                
        }).first else { return}
        
        DispatchQueue.init(label: "stoic.predicting").async { [weak self] in
            
            let testData = DataSet(
               dataType: .Regression,
               inputDimension: StockKitUtils.inDim,
               outputDimension: StockKitUtils.outDim)
            do {
                let dataSet = StockKitUtils.Models.DataSet(
                    recentStock,
                    StockSentimentData.emptyWithValues(
                        positive: positive,
                        negative: negative,
                        neutral: neutral),
                    updated: true)
                
                print("PREDICTING\n\(dataSet.description)")
                
                try testData.addTestDataPoint(
                   input: dataSet.asArray)
            }
            catch {
               print("Invalid data set created")
            }
            
            self?.model?.volatility.predictValues(data: testData)
            
            DispatchQueue.main.async {
                guard let output = testData.singleOutput(index: 0) else {
                    self?.predictionLabel.text = "open: $⚠️\nclose: $⚠️"
                    return
                }
                
                self?.predictionLabel.text = StockKitUtils.Models.DataSet.outputLabel(output)
            }
        
        }
    }
}

//MARK: Disclaimer
class ConsoleDetailDisclaimerView: UIView {
    lazy var disclaimer: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.textColor = GlobalStyle.Colors.red
        label.font = GlobalStyle.Fonts.courier(.footnote, .bold)
        label.text = "//// All predictions are never 100% accurate. Use this as a tool to estimate \"direction\"\n//// Predictions may change on each run due to newer updates in emotions\n//// found realtime on the web."
        label.numberOfLines = 0
        return label
    }()
//    lazy var disclaimer2: UILabel = {
//        let label = UILabel.init()
//        label.textAlignment = .left
//        label.textColor = GlobalStyle.Colors.red
//        label.font = GlobalStyle.Fonts.courier(.footnote, .bold)
//        label.text = "//// Predictions may change on each run due to newer updates in emotions"
//        label.numberOfLines = 0
//        return label
//    }()
//    lazy var disclaimer3: UILabel = {
//        let label = UILabel.init()
//        label.textAlignment = .left
//        label.textColor = GlobalStyle.Colors.red
//        label.font = GlobalStyle.Fonts.courier(.footnote, .bold)
//        label.text = "//// found realtime on the web."
//        label.numberOfLines = 0
//        return label
//    }()
//
//    lazy var vStack: UIStackView = {
//        let stack = UIStackView.init(arrangedSubviews: [disclaimer1, disclaimer2, disclaimer3])
//        stack.alignment = .fill
//        stack.distribution = .fill
//        stack.axis = .vertical
//        return stack
//    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        addSubview(disclaimer)
        self.disclaimer.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
