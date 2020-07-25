//
//  StockKitComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

public enum StockPrediction {
    case high
    case low
    case open
    case close
}
class StockSentimentData: NSObject {
    let date: Date
    let dateAsString: String
    let dateComponents: (year: Int, month: Int, day: Int)
    let positives: [Double]
    let neutrals: [Double]
    let negatives: [Double]
    let textData: [String]
    
    var posAverage: Double {
        var sum: Double = 0.0
        for value in positives {
            sum += value
        }
        
        return sum/Double(positives.count)
    }
    
    var negAverage: Double {
        var sum: Double = 0.0
        for value in negatives {
            sum += value
        }
        
        return sum/Double(positives.count)
    }
    
    init(
        date: Date,
        dateAsString: String,
        dateComponents: (year: Int, month: Int, day: Int),
        positives: [Double],
        neutrals: [Double],
        negatives: [Double],
        textData: [String]) {
        
        self.date = date
        self.dateAsString = dateAsString
        self.dateComponents = dateComponents
        self.positives = positives
        self.neutrals = neutrals
        self.negatives = negatives
        self.textData = textData
    }
}
class StockData: NSObject {
    var dateData: StockDateData
    var open: Double
    var high: Double
    var low: Double
    var close: Double
    var adjClose: Double
    var volume: Double
    
    init(
        dateData: StockDateData,
        open: Double,
        high: Double,
        low: Double,
        close: Double,
        adjClose: Double,
        volume: Double) {
        
        self.dateData = dateData
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.adjClose = adjClose
        self.volume = volume
    }
}
class StockDateData: NSObject {
    var asString: String
    var asDate: Date?
    var isOpen: Bool
    var dateComponents: (year: Int, month: Int, day: Int)
    
    init(
        date: Date?,
        isOpen: Bool,
        dateAsString: String) {
        self.asDate = date
        self.asString = dateAsString
        self.isOpen = isOpen

        let day = Calendar.nyCalendar.component(.day, from: asDate ?? Date())
        let month = Calendar.nyCalendar.component(.month, from: asDate ?? Date())
        let year = Calendar.nyCalendar.component(.year, from: asDate ?? Date())
        
        self.dateComponents = (year, month, day)
    }
}
public class StockKitComponent: Component<StockKitState> {
    override var reducers: [AnyReducer] {
        [
            GetValidMarketDaysReducer.Reducible(),
            GetValidMarketDaysResponseReducer.Reducible()
        ]
    }
    
    override func didLoad() {
        observeState(
            \.nextValidTradingDay,
            handler: prepared(_:))
    }
    
    func prepare() {
        processEvent(StockKitEvents.GetValidMarketDays())
    }
    
    func prepared(_ nextValidTradingDay: Change<StockDateData?>) {
        guard nextValidTradingDay.newValue != nextValidTradingDay.oldValue else
        { return }
        
        if nextValidTradingDay.newValue != nil {
            processBubbleEvent(StockKitEvents.StockKitIsPrepared())
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
    
}


//MARK: Prediction Logic
extension StockKitComponent: SVMModelDelegate {
    func predict(
        withStockData stockData: [StockData],
        stockSentimentData sentimentData: [StockSentimentData]) -> (open: SVMModel, close: SVMModel) {
        
        let dataOpen = DataSet(dataType: .Regression, inputDimension: 3, outputDimension: 1)
        
        let dataClose = DataSet(dataType: .Regression, inputDimension: 3, outputDimension: 1)
        
        for (index, stock) in stockData.enumerated() {
            do {
                try dataOpen.addDataPoint(input: [Double(index), sentimentData[index].posAverage, sentimentData[index].negAverage], output: [stock.open])
                
                try dataClose.addDataPoint(input: [Double(index), sentimentData[index].posAverage, sentimentData[index].negAverage], output: [stock.close])
            }
            catch {
                print("Invalid data set created")
            }
        }
        
        
        let svmOpen = SVMModel(
            problemType: .ϵSVMRegression,
            kernelSettings:
            KernelParameters(type: .Polynomial,
                             degree: 2,
                             gamma: 0.33,
                             coef0: 0.0))
        svmOpen.delegate = self
        svmOpen.Cost = 1e3
        svmOpen.train(data: dataOpen)
        
        let svmClose = SVMModel(
            problemType: .ϵSVMRegression,
            kernelSettings:
            KernelParameters(type: .Polynomial,
                             degree: 2,
                             gamma: 0.33,
                             coef0: 0.0))
        svmClose.delegate = self
        svmClose.Cost = 1e3
        svmClose.train(data: dataClose)
        
        
//        let testData = DataSet(dataType: .Regression, inputDimension: 1, outputDimension: 1)
//        do {
//            try testData.addTestDataPoint(input: [29])
//        }
//        catch {
//            print("Invalid data set created")
//        }
//        svm.predictValues(data: testData)
//        var outputs : [[Double]]?
//        do {
//            try outputs = testData.outputs
//        }
//        catch {
//            outputs = nil
//            print("Error in prediction")
//        }
        
        return (svmOpen, svmClose)
    }
    
    func SVMProgress(
        _ iterations: Int,
        _ maxIterations: Int) {
        
        self.processBubbleEvent(
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
                        
                        self.processBubbleEvent(
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
            csvTask = URLSession.shared.dataTask(with: url) { data, response, error in
                observation?.invalidate()
                
                if let data = data, let dates = self.state.validTradingDays {
                    if let content = String(data: data, encoding: .utf8) {
                        guard let stockData = self.parseCSV(
                           content: content,
                           forDates: dates), !stockData.isEmpty else {
                           return
                        }
                        
                        self.processBubbleEvent(
                            StockKitEvents.CSVDownloadCompleted(
                                result: stockData))
                    }
                }
            }
            
            observation = csvTask?.progress.observe(\.fractionCompleted) { progress, _ in
           
                self.processBubbleEvent(
                      StockKitEvents.CSVProgress(
                            fraction: progress.fractionCompleted))
            }
            
            csvTask?.resume()
        }
    }
    
    func getSentiment(forTicker ticker: String) {
        guard crawls < state.rules.days else {
            crawls = 0
            
            self.processBubbleEvent(
                StockKitEvents.SentimentDigetsCompleted(
                    result: sentiments))
            return
        }
        guard let date = state.date else { return }
        guard let newDate = state.advanceDate1Day(
            date: date,
            value: crawls) else {
            return
        }
        guard let aheadDate = state.advanceDate1Day(
            date: date,
            value: crawls+1) else {
            return
        }
        let dateAsString = state.dateAsString(date: newDate)
        let aheadDateAsString = state.dateAsString(date: aheadDate)
        crawls += 1
        
        
        pullTweets(
            ticker: ticker,
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
        forNextMonth nextMonth: String,
        forYear year: String,
        forPreviousYear prevYear: String,
        forNextYear nextYear: String,
        hittingPrevious: Bool = false,
        hittingAfter: Bool = false) {
        
        validMarketDaysTask?.cancel()
        let validMarketEndpointasString = "https://api.tradier.com/v1/markets/calendar?month=\(hittingPrevious ? prevMonth : (hittingAfter ? nextMonth : month))&year=\(hittingPrevious ? prevYear : hittingAfter ? nextYear : year)"
        
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
                                    let dateAsDate: Date? = self.state.dateFormatter.date(from: dateAsString)
                                    
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
                                forNextMonth: nextMonth,
                                forYear: year,
                                forPreviousYear: prevYear,
                                forNextYear: nextYear,
                                hittingPrevious: hittingPrevious == false,
                                hittingAfter: hittingPrevious)
                        }
                    }
                }
                
                if error != nil {
                    print(error?.localizedDescription)
                    print(response)
                }
            }
            
            validMarketDaysTask?.resume()
        }
    }
    func pullTweets(
        ticker: String,
        dateAsString: String,
        aheadDateAsString: String,
        date: Date) {
        
        var positives: [Double] = []
        var neutrals: [Double] = []
        var negatives: [Double] = []
        var textData: [String] = []
        
        print("{TEST} Sentiment \(ticker) \(dateAsString) \(aheadDateAsString)")
        let scraper = TwitterScraper()
        scraper.searchTweet(
            using: ticker,
            username: nil,
            near: nil,
            since: dateAsString,
            until: aheadDateAsString,
            count: 40,
            
        success:  { (results, reponse) in
            for result in results{
                let input = SentimentPolarityInput(input: self.features(from: result.text))
                
                let score = self.predictionSentimentScore(
                    with: [input],
                    self.classifier)
                
                if let score = score {
                    positives.append(score.pos ?? 0.0)
                    neutrals.append(score.neutral ?? 0.0)
                    negatives.append(score.negative ?? 0.0)
                    textData.append(result.text)
                }
            }
            
            let stockSentiment: StockSentimentData = .init(
                date: date,
                dateAsString: dateAsString,
                dateComponents: self.state.dateComponents(fromDate: date),
                positives: positives,
                neutrals: neutrals,
                negatives: negatives,
                textData: textData)
                
            self.sentiments.append(stockSentiment)
            self.getSentiment(forTicker: ticker)
        }, progress: { _, _ in
            self.processBubbleEvent(
                StockKitEvents.SentimentProgress(
                    sentiment: self.sentiments.randomElement(),
                    fraction: Double(self.crawls)/Double(self.state.rules.days)))
        },
        failure: {  error in
            
        })
        
//        state.swifter.searchTweet(
//            using: ticker,
//            lang: "en",
//            count: 12000,
//            until: dateAsString,//pulls tweets from this day (-1), not until
//            tweetMode: .extended,
//            success: { (results, metadata) in
//
//            for i in 0..<(results.array?.count ?? 0){
//                if let tweet = results[i]["full_text"].string{
//                    let input = SentimentPolarityInput(input: self.features(from: tweet))
//
//                    let score = self.predictionSentimentScore(
//                        with: [input],
//                        self.classifier)
//
//                    if let score = score {
//                        positives.append(score.pos ?? 0.0)
//                        neutrals.append(score.neutral ?? 0.0)
//                        negatives.append(score.negative ?? 0.0)
//                        textData.append(tweet)
//                    }
//                }
//            }
//
//
//            let stockSentiment: StockSentimentData = .init(
//                date: date,
//                dateAsString: dateAsString,
//                dateComponents: self.state.dateComponents(fromDate: date),
//                positives: positives,
//                neutrals: neutrals,
//                negatives: negatives,
//                textData: textData)
//
//            self.sentiments.append(stockSentiment)
//            self.getSentiment(forTicker: ticker)
//        }) { (error) in
//            print("some error in searching tweets \(error)")
//        }
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
