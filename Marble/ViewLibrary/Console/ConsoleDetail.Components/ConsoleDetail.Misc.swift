//
//  ConsoleDetail.Misc.swift
//  Stoic
//
//  Created by Ritesh Pakala on 11/23/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

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
