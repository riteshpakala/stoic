//
//  StockKitComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class StockKitComponent: Component<StockKitState> {
    override public var reducers: [AnyReducer] {
        [
            GetValidMarketDaysReducer.Reducible(),
            GetValidMarketDaysResponseReducer.Reducible()
        ]
    }
    
    override public func didLoad() {
        observeState(
            \.nextValidTradingDay,
            handler: prepared(_:))
    }
    
    override public func rip() {
        super.rip()
        
        searchTask?.cancel()
        csvTask?.cancel()
        validMarketDaysTask?.cancel()
        scraper.cancel()
    }
    
    func prepare() {
        processEvent(StockKitEvents.GetValidMarketDays())
    }
    
    func prepared(_ nextValidTradingDay: Change<StockDateData?>) {
        guard nextValidTradingDay.newValue != nextValidTradingDay.oldValue else
        { return }
        
        if nextValidTradingDay.newValue != nil {
            bubbleEvent(StockKitEvents.StockKitIsPrepared())
        }
    }
    
    //MARK: Sentiment Constants
    let classifier: SentimentPolarity = .init()
    let options: NSLinguisticTagger.Options = [
        .omitWhitespace,
        .omitPunctuation,
        .omitOther]
    
    lazy var tagger: NSLinguisticTagger = {
        .init(
          tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"),
          options: Int(options.rawValue)
        )
    }()
    var crawls: Int = 0
    var sentiments: [StockSentimentData] = []
    
    //MARK: ValidDays
    var stockDates: [StockDateData] = []
    
    //MARK: Search & CSV Constants
    var searchTask: URLSessionTask? = nil
    var csvTask: URLSessionTask? = nil
    var validMarketDaysTask: URLSessionTask? = nil
    let scraper = TwitterScraper()
    var disable: Bool = false
}


//MARK: Prediction Logic
extension StockKitComponent: SVMModelDelegate {
    func predict(
        withStockData stockData: [StockData],
        stockSentimentData sentimentData: [StockSentimentData]) -> StockKitUtils.Models {
        
        let dataVolatility = DataSet(
            dataType: .Regression,
            inputDimension: StockKitUtils.inDim,
            outputDimension: StockKitUtils.outDim)
        
        let sortedStockData = stockData.sorted(
            by: {
                ($0.dateData.asDate ?? Date()).compare(($1.dateData.asDate ?? Date())) == .orderedAscending })
        
        
        let sortedSentimentStockData = sentimentData.sorted(
            by: {
                ($0.date).compare($1.date) == .orderedAscending })
        
        for (i, stock) in sortedStockData.enumerated() {
            do {
                guard sortedSentimentStockData.count > i else { continue }
                let sentiment = sortedSentimentStockData[i]
                let dataSet = StockKitUtils.Models.DataSet(
                    stock,
                    sentiment)
                
                print(dataSet.description)
                
                try dataVolatility.addDataPoint(
                    input: dataSet.asArray,
                    output: dataSet.output)
            }
            catch {
                print("Invalid data set created")
            }
        }
        
        let svmVolatility = SVMModel(
            problemType: .ϵSVMRegression,
            kernelSettings:
            KernelParameters(type: .Polynomial,
                             degree: 3,
                             gamma: 0.3,
                             coef0: 0.0))
        svmVolatility.delegate = self
        svmVolatility.Cost = 1e3
        svmVolatility.train(data: dataVolatility)
        
        return StockKitUtils.Models(volatility: svmVolatility)
    }
    
    func SVMProgress(
        _ iterations: Int,
        _ maxIterations: Int) {
        
        self.bubbleEvent(
            StockKitEvents.PredictionProgress.init(
                maxIterations: maxIterations,
                iterations: iterations))
    }
}

//MARK: Data Ingestion Logic
extension StockKitComponent {
    func getValidMarketDays(
        forMonth month: String,
        forYear year: String) {
        
        let sanitizedMonth: String
        let previousMonth: String
        let previousMonth2: String
        let nextMonth: String
        let previousYear: String
        let nextYear: String
        if let intMonth = Int(month) {
            if intMonth < 10 {
                sanitizedMonth = "0"+month
            } else {
                sanitizedMonth = month
            }
            
            if intMonth == 1 {
                previousMonth = "12"
            } else if intMonth <= 10 {
                previousMonth = "0"+String(intMonth-1)
            } else {
                previousMonth = String(intMonth-1)
            }
            
            if intMonth == 1 {
                previousMonth2 = "11"
            } else if intMonth == 2 {
                previousMonth2 = "12"
            } else if intMonth <= 11 {
                previousMonth2 = "0"+String(intMonth-2)
            } else {
                previousMonth2 = String(intMonth-2)
            }
            
            if intMonth == 12 {
                nextMonth = "01"
            } else if intMonth < 9 {
                nextMonth = "0"+String(intMonth+1)
            } else {
                nextMonth = String(intMonth+1)
            }
        } else {
            sanitizedMonth = month
            previousMonth = month
            previousMonth2 = month
            nextMonth = month
        }
        
        if let intYear = Int(year), Int(previousMonth) == 12 {
            previousYear = String(intYear-1)
        } else {
            previousYear = year
        }
        
        if let intYear = Int(year), Int(nextMonth) == 1 {
            nextYear = String(intYear+1)
        } else {
            nextYear = year
        }
        
        pullMarketDays(
            forMonth: sanitizedMonth,
            forPreviousMonth: previousMonth,
            forPreviousMonth2: previousMonth2,
            forNextMonth: nextMonth,
            forYear: year,
            forPreviousYear: previousYear,
            forNextYear: nextYear)
        
    }
    
    func fetchStocksFromSearchTerm(term: String) {
        searchTask?.cancel()
        
        let searchURLasString = "https://symlookup.cnbc.com/symservice/symlookup.do?prefix=\(term)&partnerid=20064&pgok=1&pgsize=50"
        
        if let url = URL(string: searchURLasString) {
            searchTask = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] else { return }
                        
                        self.bubbleEvent(
                            StockKitEvents.SearchCompleted(
                                result: dict))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                if error != nil {
                    print(error?.localizedDescription)
                    print(response)
                }
            }
            
            searchTask?.resume()
        }
    }
    func getCSV(forTicker ticker: String) {
        csvTask?.cancel()
        
        let csvURLasString = "https://query1.finance.yahoo.com/v7/finance/download/\(ticker)?period1=1092873600&period2=\(state.yahooFinanceAPIHistoryKey)&interval=1d&events=history"
        
        
        if let url = URL(string: csvURLasString) {
            var observation: NSKeyValueObservation? = nil
            csvTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                observation?.invalidate()
                
                guard let this = self else { return }
                
                if let data = data, let dates = this.state.validHistoricalTradingDays {
                    if let content = String(data: data, encoding: .utf8) {
                        guard let stockData = this.parseCSV(
                           content: content,
                           forDates: dates), !stockData.isEmpty else {
                           return
                        }
                        
                        if let validTradingDays = this.state.validTradingDays {

                            let datesAsStrings = validTradingDays.map { $0.asString }
                            let observedStocks: [StockData] = stockData.filter { datesAsStrings.contains($0.dateData.asString) }
                            
                            let updatedStocks: [StockData] = observedStocks.map {
                                $0.update(
                                    historicalTradingData: stockData,
                                    rsiMax: this.state.rules.rsiMaxHistorical)
                            }
                            
                            this.bubbleEvent(
                                StockKitEvents.CSVDownloadCompleted(
                                    result: updatedStocks ))
                        }
                    }
                }
            }
            
            observation = csvTask?.progress.observe(\.fractionCompleted) { progress, _ in
           
                self.bubbleEvent(
                      StockKitEvents.CSVProgress(
                            fraction: progress.fractionCompleted))
            }
            
            csvTask?.resume()
        }
    }
    
    func getSentiment(forSearch payload: StockSearchPayload) {
        guard crawls < state.rules.days,
              let validTradingDays = state.validTradingDays,
              crawls < validTradingDays.count else {
            crawls = 0
            
            self.bubbleEvent(
                StockKitEvents.SentimentDigetsCompleted(
                    result: sentiments))
            return
        }
        guard let date = validTradingDays[crawls].asDate else { return }
        
        guard let aheadDate = state.advanceDate1Day(
            date: date,
            value: -1) else {
            return
        }
        
        let dateAsString = state.dateAsString(date: date)
        let aheadDateAsString = state.dateAsString(date: aheadDate)
        crawls += 1
        
        pullTweets(
            forSearch: payload,
            dateAsString: dateAsString,
            aheadDateAsString: aheadDateAsString,
            date: date)
    }
}

//MARK: Data Ingestion Tools
extension StockKitComponent {
    func pullMarketDays(
        forMonth month: String,
        forPreviousMonth prevMonth: String,
        forPreviousMonth2 prevMonth2: String,
        forNextMonth nextMonth: String,
        forYear year: String,
        forPreviousYear prevYear: String,
        forNextYear nextYear: String,
        hittingPrevious: Bool = false,
        hittingPrevious2: Bool = false,
        hittingAfter: Bool = false) {
        
        validMarketDaysTask?.cancel()
        
        let monthToScrape: String
        if hittingPrevious2 {
            monthToScrape = prevMonth2
        } else if hittingPrevious {
            monthToScrape = prevMonth
        } else if hittingAfter {
            monthToScrape = nextMonth
        } else {
            monthToScrape = month
        }
        
        let validMarketEndpointasString = "https://api.tradier.com/v1/markets/calendar?month=\(monthToScrape)&year=\(hittingPrevious ? prevYear : hittingAfter ? nextYear : year)"
        
        if let url = URL(string: validMarketEndpointasString) {
            validMarketDaysTask = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    
                    if let content = String(data: data, encoding: .utf8) {
                        
                        let contentSplitStep1 = content.components(separatedBy: "</status>")
                        
                        for contentSplit in contentSplitStep1 {
                            if let lastItem = contentSplit.components(separatedBy: "<date>").last {
                                let dateAndStatusSplit = lastItem.components(separatedBy: "</date><status>")
                                if  dateAndStatusSplit.count > 1,
                                    let date = dateAndStatusSplit.first,
                                    let status = dateAndStatusSplit.last {
                                    
                                    let dateAsString: String = date
                                    let isOpen: Bool = status == "open" ? true : false
                                    let dateAsDate: Date? = dateAsString.asDate()
                                    
                                    let stockDateData: StockDateData = .init(
                                        date: dateAsDate,
                                        isOpen: isOpen,
                                        dateAsString: dateAsString)
                                    
                                    self.stockDates.append(stockDateData)
                                }
                            }
                        }
                        
                        if hittingAfter {
                            self.processEvent(
                                StockKitEvents.ValidMarketDaysCompleted(
                                    result: self.stockDates))
                        } else {
                            self.pullMarketDays(
                                forMonth: month,
                                forPreviousMonth: prevMonth,
                                forPreviousMonth2: prevMonth2,
                                forNextMonth: nextMonth,
                                forYear: year,
                                forPreviousYear: prevYear,
                                forNextYear: nextYear,
                                hittingPrevious: hittingPrevious2,
                                hittingPrevious2: !hittingPrevious2 && !hittingPrevious,
                                hittingAfter: hittingPrevious)
                        }
                    }
                }
                
                if error != nil {
                    print(error?.localizedDescription ?? "error could not be transcribed")
                    print(response ?? "response could not be transcribed")
                }
            }
            
            validMarketDaysTask?.resume()
        }
    }
    func pullTweets(
        forSearch payload: StockSearchPayload,
        dateAsString: String,
        aheadDateAsString: String,
        date: Date) {
        
        var sentimentData: [VaderSentimentOutput] = []
        var tweetData: [Tweet] = []
        
        print("{TEST} Sentiment \(payload.asString) \(dateAsString) \(aheadDateAsString)")
        
        scraper.begin(
            using: payload,
            username: nil,
            near: nil,
            since: aheadDateAsString,
            until: dateAsString,
            count: state.rules.tweets,
            filterLangCode: state.rules.baseLangCode,
            
        success:  { [weak self] (results, reponse) in
            for result in results{
                let vaderSentiment = VaderSentiment.predict(result.text)
                
                if vaderSentiment.compound != .zero {
                    sentimentData.append(vaderSentiment)
                    tweetData.append(result)
                }
            }
            
            self?.pushSentiment(
                date,
                aheadDateAsString,
                dateAsString,
                sentimentData,
                tweetData,
                payload)
        }, progress: { [weak self] text, count in
            guard let this = self else { return }
            
            let sentimentGatheredValueTotal: Double = Double(this.sentiments.map { $0.positives.count }.reduce(0, +))
            let sentimentGatheredDiff: Double = abs(sentimentGatheredValueTotal - Double(this.sentiments.count*this.state.rules.tweets))
            let sentimentMaxGathered: Double = Double(this.state.rules.days * this.state.rules.tweets) - Double(sentimentGatheredDiff)
            this.bubbleEvent(
                StockKitEvents.SentimentProgress(
                    text: text,
                    fraction: (count+sentimentGatheredValueTotal)/sentimentMaxGathered))
        },
        failure: {  error in
            
        })
    }
    
    func pushSentiment(
        should: Bool = true,
        _ date: Date,
        _ aheadDateAsString: String,
        _ dateAsString: String,
        _ sentimentData: [VaderSentimentOutput],
        _ tweetData: [Tweet],
        _ payload: StockSearchPayload) {
        guard should else { return }
        let stockSentiment: StockSentimentData = .init(
            date: date,
            dateAsString: aheadDateAsString,
            stockDateRefAsString: dateAsString,
            sentimentData: sentimentData,
            tweetData: tweetData)
         
        
        self.sentiments.append(stockSentiment)
        self.getSentiment(forSearch: payload)
    }
}

extension StockKitComponent {
    func parseCSV (
        content: String,
        forDates dates: [StockDateData])
        -> [StockData]? {
            
       // Load the CSV file and parse it
        let delimiter = ","
        var items:[StockData]? = []

        let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]

        for line in lines {
            var stockDateData: StockDateData? = nil
            var values:[String] = []
            if line != "" {
                // For a line with double quotes
                // we use NSScanner to perform the parsing
                if line.range(of: "\"") != nil {
                    var textToScan:String = line
                    var value:NSString?
                    var textScanner:Scanner = Scanner(string: textToScan)
                    while textScanner.string != "" {

                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
                            textScanner.scanLocation += 1
                            textScanner.scanUpTo("\"", into: &value)
                            textScanner.scanLocation += 1
                        } else {
                            textScanner.scanUpTo(delimiter, into: &value)
                        }

                        // Store the value into the values array
                        if let value = value as String? {
                            values.append(value)
                        }
                        

                        // Retrieve the unscanned remainder of the string
                        if textScanner.scanLocation < textScanner.string.count {
                            textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                        } else {
                            textToScan = ""
                        }
                        textScanner = Scanner(string: textToScan)
                    }

                    // For a line without double quotes, we can simply separate the string
                    // by using the delimiter (e.g. comma)
                } else  {
                    values = line.components(separatedBy: delimiter)
                    if let first = values.first {
                        stockDateData = dates.first(where: { $0.asString == first })
                    }
                }
                
                if  let dateData = stockDateData,//Double(values[0]),
                    let open = Double(values[1]),
                    let high = Double(values[2]),
                    let low = Double(values[3]),
                    let close = Double(values[4]),
                    let adjClose = Double(values[5]),
                    let volume = Double(values[6]) {
                    
                    let item: StockData = StockData.init(
                        dateData: dateData,
                        open:open,
                        high:high,
                        low:low,
                        close:close,
                        adjClose:adjClose,
                        volume: volume)

                    // Put the values into the tuple and add it to the items array
                    
                    items?.append(item)
                }
                
                stockDateData = nil
                
            }
        }

        return items
    }
}

extension StockKitComponent {
    func predictionSentimentScore(
        with tweets : [SentimentPolarityInput],
        _ model: SentimentPolarity) -> (pos: Double?, neutral: Double?, negative: Double?)? {

        var score: (pos: Double?, neutral: Double?, negative: Double?)? = nil
        do{
            let predictions = try model.predictions(inputs: tweets)
            
            
            for (prediction) in predictions {
                score = (prediction.classProbability["Pos"], prediction.classProbability["Neutral"],  prediction.classProbability["Neg"])
            }
        }catch{
            print("error predicting \(error)")
        }
        return score
    }

    func features(from text: String) -> [String: Double] {
        
        var wordCounts = [String: Double]()

        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)

        // Tokenize and count the sentence
        tagger.enumerateTags(in: range, scheme: .nameType, options: options) { _, tokenRange, _, _ in
            let token = (text as NSString).substring(with: tokenRange).lowercased()
            // Skip small words
            guard token.count >= 3 else {
              return
            }

            if let value = wordCounts[token] {
                wordCounts[token] = value + 1.0
            } else {
                wordCounts[token] = 1.0
            }
        }

        return wordCounts
    }
}
