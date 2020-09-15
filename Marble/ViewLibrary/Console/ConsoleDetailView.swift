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

class ConsoleDetailView: GraniteView {
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
    override init(frame: CGRect) {
        self.baseFrame = frame
        super.init(frame: frame)
        
        loader = .init(self, baseText: " /* thinking\(ConsoleLoader.seperator) */")
        addSubview(headerView)
        addSubview(sentimentView)
        addSubview(disclaimerView)
        addSubview(predictionView)
        addSubview(historicalView)
        addSubview(loaderView)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(baseSize.height*0.12)
        }
        
        historicalView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(baseSize.height*0.24)
        }
        
        sentimentView.snp.makeConstraints { make in
            make.top.equalTo(historicalView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(baseSize.height*0.24)
        }
        
        predictionView.snp.makeConstraints { make in
            make.top.equalTo(sentimentView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(baseSize.height*0.24)
        }
        
        disclaimerView.snp.makeConstraints { make in
            make.top.equalTo(predictionView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(baseSize.height*0.16)
        }
        
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        predictionView.delegate = self
        sentimentView.delegate = self
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(_ payload: ConsoleDetailPayload) {
        stockSymbol = "$"+(payload.historicalTradingData.first?.symbolName ?? "")
        headerView.updateTradingDay(payload.currentTradingDay)
        historicalView.updateData(
            payload.historicalTradingData.reversed(),
            payload.stockSentimentData)
        
        predictionView.updateModel(
            model: payload.model,
            stockData: payload.historicalTradingData)
    }
    
    func updateThink(_ payload: ThinkPayload?) {
        thinkingStopped()
        if let sentiment = payload?.stockSentimentData {
            sentimentView.updateSlider(sentiment)
            sentimentChanged(
                sentiment.posAverage,
                negative: sentiment.negAverage,
                neutral: sentiment.neuAverage,
                compound: sentiment.compoundAverage)
        }
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

        if  adjHistoricalTableViewFrame.contains(point),
            historicalView.expand,
            !adjHistoricalIndicatorFrame.contains(point) {
            
            return historicalView.historicDatePicker
        } else {
            return super.hitTest(point, with: event)
        }
    }
}

extension ConsoleDetailView: ConsoleLoaderDelegate {
    public func consoleLoaderUpdated(_ indicator: String) {
        if let consoleView = superview as? ConsoleView, let symbol = stockSymbol {
            consoleView.tickerLabel.text = symbol+indicator
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
}

//MARK: Header
class ConsoleDetailHeaderView: GraniteView {
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
            make.top.equalToSuperview().offset(GlobalStyle.padding)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTradingDay(_ date: String) {
        currentTradingDay.text = "\("trading day".localized): "+date
    }
}

//MARK: Historical
class ConsoleDetailHistoricalView: GraniteView, PickerDelegate {
    lazy var historicDatePicker: StockDatePicker = {
        return .init(color: GlobalStyle.Colors.green)
    }()
    
    lazy var indicator: TriangleView = {
        let triangle: TriangleView = .init(
            frame: .zero,
            color: GlobalStyle.Colors.green)
        triangle.backgroundColor = GlobalStyle.Colors.black
        return triangle
    }()
    
    var expand: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.expand {
                    self.historicDatePicker.snp.remakeConstraints { make in
                        make.left.equalToSuperview().offset(GlobalStyle.padding)
                        make.width.equalToSuperview().multipliedBy(0.48)
                        make.height.equalTo(self.expandSize)
                        make.top.equalToSuperview().offset(self.historicDatePicker.frame.origin.y)
                    }
                } else {
                    self.historicDatePicker.snp.remakeConstraints { make in
                        make.left.equalToSuperview().offset(GlobalStyle.padding)
                        make.width.equalToSuperview().multipliedBy(0.48)
                        make.height.equalToSuperview().multipliedBy(0.66)
                        make.centerY.equalToSuperview()
                    }
                    
                    self.historicDatePicker.scrollTo(self.currentIndex, animated: true)
                }
            }
        }
    }
    
    lazy var emotionLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.green
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.text = "\("positive".localized.lowercased()): 50%\n\("negative".localized.lowercased()): 50%"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var openLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.green
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 0
        label.text = "\("open".localized.lowercased()): $0000.00\n\("close".localized.lowercased()): $0000.00"
        return label
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView.init(arrangedSubviews: [emotionLabel, openLabel])
        stack.alignment = .center
        stack.distribution = .fill
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var tapGestureTableView: UITapGestureRecognizer = {
        return .init(target: self, action: #selector(self.tapRegistered(_:)))
    }()
    
    var expandSize: CGFloat {
        self.cellsToViewWhenExpanded * self.historicDatePicker.cellHeight
    }
    var cellHeight: CGFloat {
        didSet {
            historicDatePicker.cellHeight = cellHeight
        }
    }
    var cellsToViewWhenExpanded: CGFloat
    
    private var stockData: [StockData]? = nil
    private var sentimentStockData: [StockSentimentData]? = nil
    private var currentIndex: Int = 0 {
        didSet {
            updateStats()
        }
    }
    init(
        cellHeight: CGFloat = 30,
        cellsToViewWhenExpanded: CGFloat = 3) {
        self.cellHeight = cellHeight
        self.cellsToViewWhenExpanded = cellsToViewWhenExpanded
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        historicDatePicker.cellHeight = cellHeight
        historicDatePicker.pickerDelegate = self
        
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
        historicDatePicker.expandedPadding = Int(cellsToViewWhenExpanded - 1)
        
        stockData = data
        sentimentStockData = sentimentData
        
        updateStats()
    }
    
    public func updateStats() {
        guard
            let data = stockData,
            let sentimentData = sentimentStockData,
            currentIndex < data.count else {
                openLabel.text = "⚠️"
                emotionLabel.text = "⚠️"
                return
        }
        
        let stock = data[currentIndex]
        openLabel.text = "\("open".localized.lowercased()): $\(round(stock.open*100)/100)\n\("close".localized.lowercased()): $\(round(stock.close*100)/100)"
        
        guard let sentiment = sentimentData.first(
            where: { $0.stockDateRefAsString == stock.dateData.asString }) else {
            
                emotionLabel.text = "⚠️"
                return
        }
        
        emotionLabel.text = "\("positive".localized.lowercased()): \(Int(sentiment.posAverage*100))%\n\("negative".localized.lowercased()): \(Int(sentiment.negAverage*100))%"
    }
    
    @objc
    func tapRegistered(_ sender: UITapGestureRecognizer) {
        expand.toggle()
        indicator.rotate()
    }
    
    func didSelect(index: Int) {
        guard index < (stockData?.count ?? 0) else {
            return
        }
        DispatchQueue.main.async {
            self.feedbackGenerator.impactOccurred()
            self.currentIndex = index
        }
    }
}

//MARK: Sentiment
protocol ConsoleDetailSentimentViewDelegate: class {
    func sentimentChanged(
        _ positive: Double,
        negative: Double,
        neutral: Double,
        compound: Double)
}
class ConsoleDetailSentimentView: GraniteView {
    enum SentimentDetail: String {
        case positive = "positive"
        case negative = "negative"
        case neutral = "neutral"
        case delta = "leaning"
        case negCompound = "| -neg bias"
        case posCompound = "| -pos bias"
    }
    
    weak var delegate: ConsoleDetailSentimentViewDelegate?
    
    lazy var compoundSlider: UISlider = {
        let view: UISlider = .init(frame: .zero)
        view.tintColor = GlobalStyle.Colors.orange
        view.setValue(0.5, animated: false)
        view.addTarget(self, action: #selector(self.sliderValue(_:)), for: .valueChanged)
        return view
    }()
    
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
    
    lazy var seperator1: UIView = {
        let label = UIView.init()
        label.backgroundColor = GlobalStyle.Colors.orange
        return label
    }()
    
    lazy var seperator2: UIView = {
        let label = UIView.init()
        label.backgroundColor = GlobalStyle.Colors.orange
        return label
    }()
    
    lazy var emotionTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 1
        label.text = "neutral".localized
        return label
    }()
    
    lazy var emotionLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 1
        label.text = "[50%:50%]"
        return label
    }()
    
    lazy var refineLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 1
        label.text = "Δ:0%"
        label.isHidden = true
        return label
    }()
    
    lazy var compoundLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.orange
        label.font = GlobalStyle.Fonts.courier(.small, .bold)
        label.numberOfLines = 1
        label.text = "λ:0"
        label.isHidden = true
        return label
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView.init(
            arrangedSubviews: [
                refineSlider,
                seperator1,
                slider,
                seperator2,
                compoundSlider])
        stack.alignment = .center
        stack.distribution = .fill
        stack.axis = .horizontal
        stack.setCustomSpacing(GlobalStyle.padding, after: refineSlider)
        stack.setCustomSpacing(GlobalStyle.padding, after: seperator1)
        stack.setCustomSpacing(GlobalStyle.padding, after: slider)
        stack.setCustomSpacing(GlobalStyle.padding, after: seperator2)
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        addSubview(hStack)
        addSubview(emotionLabel)
        addSubview(refineLabel)
        addSubview(compoundLabel)
        addSubview(emotionTitleLabel)
        
        hStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        refineSlider.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.24)
        }
        
        compoundSlider.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.24)
        }
        
        seperator1.snp.makeConstraints { make in
            make.width.equalTo(GlobalStyle.spacing/2)
            make.height.equalToSuperview().multipliedBy(0.66)
        }
        seperator2.snp.makeConstraints { make in
            make.width.equalTo(GlobalStyle.spacing/2)
            make.height.equalToSuperview().multipliedBy(0.66)
        }
        
        refineLabel.sizeToFit()
        emotionLabel.sizeToFit()
        compoundLabel.sizeToFit()
        emotionTitleLabel.sizeToFit()
        
        refineLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        emotionLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        compoundLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        emotionTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.padding)
            make.right.equalToSuperview().offset(-GlobalStyle.padding)
            make.top.equalToSuperview()
            make.height.equalTo(emotionTitleLabel.frame.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        emotionLabel.center = .init(
            x: self.center.x,
            y: hStack.frame.maxY)
    }
    
    func updateSlider(
        _ sentiment: StockSentimentData) {
        DispatchQueue.main.async {
            self.refineSlider.setValue(
                Float(sentiment.neuAverage),
                animated: true)
            
            self.slider.setValue(
                Float(0.5 + (0.5*(sentiment.posAverage-sentiment.negAverage))),
                animated: true)
            
            
            self.compoundSlider.setValue(
                Float(0.5*(1.0 + sentiment.compoundAverage)),
                animated: true)
            
            self.updateEmotionCharacteristics(
                neuPercent: Int(sentiment.neuAverage*100),
                negPercent: Int(sentiment.negAverage*100),
                posPercent: Int(sentiment.posAverage*100),
                compound: Float(sentiment.compoundAverage))
            
            self.updateEmotionTrack()
        }
    }
    
    @objc func sliderValue(
        _ slider: UISlider) {
        
        let neuValue = self.refineSlider.value
        var posValue = self.slider.value
        var negValue = abs(self.slider.value - 1.0)
        
        let compoundValue1 = self.compoundSlider.value
        let compoundValue2 = abs(self.compoundSlider.value - 1.0)
        
        let diff = abs(1.0 - (posValue + negValue + neuValue))
        posValue -= diff/2
        negValue -= diff/2
        posValue = posValue < 0 ? 0 : posValue
        negValue = negValue < 0 ? 0 : negValue
        
        let posPercent = Int(posValue*100)
        let negPercent = Int(negValue*100)
        let neuPercent = Int(neuValue*100)
        var compound = round((compoundValue1 - compoundValue2)*100)/100
        compound = compound > -0.01 && compound < 0.01 ? 0.0 : compound
        
        updateEmotionCharacteristics(
            neuPercent: neuPercent,
            negPercent: negPercent,
            posPercent: posPercent,
            compound: compound)
        
        
        updateEmotionTrack()
        
        delegate?.sentimentChanged(
            Double(posValue),
            negative: Double(negValue),
            neutral: Double(neuValue),
            compound: Double(compound))
        
    }
    
    func updateEmotionCharacteristics(
        neuPercent: Int,
        negPercent: Int,
        posPercent: Int,
        compound: Float,
        padding: Int = 5) {
        
        refineLabel.text = "Δ:\(neuPercent)%"
        emotionLabel.text = "[\(negPercent)%:\(posPercent)%]"
        compoundLabel.text = "λ:\(compound)"
        
        var characteristics: [SentimentDetail] = []
        
        if neuPercent > padding {
            //Refine General Emotion
            characteristics.append(.delta)
        }
        
        if negPercent > posPercent + 5 {
            //Negative Emotion
            characteristics.append(.negative)
        } else if posPercent > negPercent + 5 {
            //Positive Emotion
            characteristics.append(.positive)
        } else {
            //Neutral Emotion
            characteristics.append(.neutral)
        }
        
        if compound > 0.0 {
            //Positive words
            characteristics.append(.posCompound)
        } else if compound < 0.0{
            //Negative words
            characteristics.append(.negCompound)
        } else {
            //Neutral words
        }
        
        let finalStatement: String = characteristics.map { $0.rawValue.localized }.joined(separator: " ")
        emotionTitleLabel.text = finalStatement
    }
    
    func updateEmotionTrack() {
        refineLabel.isHidden = false
        compoundLabel.isHidden = false
        
        emotionLabel.center = .init(
            x: slider.thumbCenterX + GlobalStyle.padding,
            y: hStack.frame.maxY)
        
        refineLabel.center = .init(
            x: refineSlider.thumbCenterX + GlobalStyle.padding,
            y: hStack.frame.maxY)
        
        compoundLabel.center = .init(
            x: compoundSlider.thumbCenterX + GlobalStyle.padding,
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
protocol ConsoleDetailPredictionViewDelegate: class {
    func thinking()
}
class ConsoleDetailPredictionView: GraniteView {
    weak var delegate: ConsoleDetailPredictionViewDelegate?
    
    lazy var thinkTriggerContainer: UIView = {
        let view: UIView = .init()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = false
        return view
    }()
    lazy var thinkTrigger: UIView = {
        let view: UIView = .init()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = false
        return view
    }()
    
    lazy var predictionLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = GlobalStyle.Colors.purple
        label.font = GlobalStyle.Fonts.courier(.medium, .bold)
        label.text = "close: $0000.00"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView.init(
            arrangedSubviews: [
                predictionLabel])
        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = GlobalStyle.spacing
        return stack
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return .init(target: self, action: #selector(self.tapRegistered(_:)))
    }()
    
    private var model: StockKitUtils.Models? = nil
    private var stockData: [StockData]? = nil
    private var emitterSize: CGFloat
    init(emitterSize: CGFloat = 48) {
        self.emitterSize = emitterSize
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        addSubview(vStack)
        
        self.vStack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.spacing)
            make.right.equalToSuperview().offset(-GlobalStyle.spacing)
            make.top.equalToSuperview().offset(GlobalStyle.padding)
        }
        
        addSubview(thinkTriggerContainer)
        thinkTriggerContainer.addSubview(thinkTrigger)
        thinkTriggerContainer.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalStyle.spacing)
            make.right.equalToSuperview().offset(-GlobalStyle.spacing)
            make.top.equalTo(self.vStack.snp.bottom).offset(GlobalStyle.spacing)
            make.bottom.equalToSuperview()
        }
        thinkTrigger.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(emitterSize)
        }
        
        layoutIfNeeded()
        
        thinkTrigger.addGestureRecognizer(tapGesture)
        
        thinkTrigger.layer.cornerRadius = (emitterSize)/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        thinkTrigger.thinkingEmitter(
            forSize: .init(
                width: emitterSize,
                height: emitterSize),
            lifetime: 0.75)
    }
    
    @objc
    func tapRegistered(_ sender: UITapGestureRecognizer) {
        feedbackGenerator.impactOccurred()
        delegate?.thinking()
        thinkTriggerContainer.thinkingEmitter(
            forSize: thinkTriggerContainer.bounds.size,
            renderMode: .backToFront,
            color: GlobalStyle.Colors.purple)
        sender.isEnabled = false
        bubbleEvent(DetailEvents.Think())
    }
    
    func stopAnimation() {
        DispatchQueue.main.async {
            self.tapGesture.isEnabled = true
            self.thinkTriggerContainer
                .layer.sublayers?.removeAll(
                where: {
                    ($0 as? CAEmitterLayer) != nil
            })
        }
    }
    
    func updateModel(
        model: StockKitUtils.Models,
        stockData: [StockData]) {
        self.model = model
        self.stockData = stockData
        predict()
    }
    
    public func predict(
        positive: Double = 0.5,
        negative: Double = 0.5,
        neutral: Double = 0.0,
        compound: Double = 0.0) {
        
        stopAnimation()
        
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
            
            let sentimentWeights = StockSentimentData.emptyWithValues(
                positive: positive,
                negative: negative,
                neutral: neutral,
                compound: compound)
            
            do {
                let dataSet = StockKitUtils.Models.DataSet(
                    recentStock,
                    sentimentWeights,
                    updated: true)
                
                print("********************\nPREDICTING\n\(dataSet.description)")
                
                try testData.addTestDataPoint(
                   input: dataSet.asArray)
            }
            catch {
               print("Invalid data set created")
            }
            
            self?.model?.david.predictValues(data: testData)
            
            DispatchQueue.main.async {
                guard let output = testData.singleOutput(index: 0) else {
                    self?.predictionLabel.text = "open: $⚠️\nclose: $⚠️"
                    return
                }
                
                print("[Prediction Output] :: \(output)")
                
                self?.predictionLabel.text = StockKitUtils.Models.DataSet.outputLabel(output)
                
                guard !output.isNaN else { return }
                self?.bubbleEvent(
                    DetailEvents.PredictionDidUpdate(
                        close: output,
                        stockSentimentData: sentimentWeights),
                    async: DispatchQueue.init(label: "stoic.prediction.didUpdate"))
                
            }
            
        }
    }
}

//MARK: Disclaimer
class ConsoleDetailDisclaimerView: GraniteView {
    lazy var disclaimer: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.textColor = GlobalStyle.Colors.red
        label.font = GlobalStyle.Fonts.courier(.footnote, .bold)
        label.text = "//// \("All predictions are never 100% accurate. Use this as a tool to estimate direction on top of your manual technical analysis.".localized)\n//// \("Predictions may change on each run due to newer updates in emotions found realtime on the web.".localized)\n//// \("Have questions or feedback?".localized+" Email: team@linenandsole.com")"
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
