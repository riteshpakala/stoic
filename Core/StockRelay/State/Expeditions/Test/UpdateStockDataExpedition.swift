//
//  UpdateStockDataExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct UpdateStockDataExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.UpdateStockData
    typealias ExpeditionState = StockState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        
        let todaysDate: Date = Date.today
        let testDate: Date = Date.today.advanceDate(value: -7)
        
        print("{TEST} \(testDate)")
        publisher = state
            .service
            .getStock(matching: "MSFT",
                             from: "\(Int(testDate.timeIntervalSince1970))",//"1591833600",
                             to: "\(Int(todaysDate.timeIntervalSince1970))")
            .replaceError(with: [])
            .map { StockEvents.NewStockData(data: $0) }
            .eraseToAnyPublisher()
        
        
        print("{TEST} stocks should update")
    }
    
//    var csvTask: URLSessionTask? = nil
//    func getCSV(forTicker ticker: String) {
//        csvTask?.cancel()
//
//        let csvURLasString = "https://query1.finance.yahoo.com/v7/finance/download/\(ticker)?period1=1092873600&period2=\(state.yahooFinanceAPIHistoryKey)&interval=1d&events=history"
//
//
//        if let url = URL(string: csvURLasString) {
//            var observation: NSKeyValueObservation? = nil
//            csvTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//                observation?.invalidate()
//
//                guard let this = self else { return }
//
//                if let data = data, let dates = this.state.validHistoricalTradingDays {
//                    if let content = String(data: data, encoding: .utf8) {
//                        guard let stockData = this.parseCSV(
//                           content: content,
//                           forDates: dates), !stockData.isEmpty else {
//                           return
//                        }
//
//                        if let validTradingDays = this.state.validTradingDays {
//                            let datesAsStrings = validTradingDays.map { $0.asString }
//                            let observedStocks: [StockData] = stockData.filter { datesAsStrings.contains($0.dateData.asString) }
//
//                            let updatedStocks: [StockData] = observedStocks.map {
//                                $0.update(
//                                    historicalTradingData: stockData,
//                                    rsiMax: this.state.rules.rsiMaxHistorical)
//                            }
//
//                            this.processBubbleEvent(
//                                StockKitEvents.CSVDownloadCompleted(
//                                    result: updatedStocks ))
//                        }
//                    }
//                }
//            }
//
//            observation = csvTask?.progress.observe(\.fractionCompleted) { progress, _ in
//
//
//            }
//
//            csvTask?.resume()
//        }
//    }
}

struct NewStockDataExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.NewStockData
    typealias ExpeditionState = StockState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
    
        
        
        print("{TEST} stocks updated \(event.data.count)")
    }
    
}

public class StockDataService {
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    public func searchPublisher(matching ticker: String, from pastEpoch: String, to futureEpoch: String) -> AnyPublisher<[StockData], URLError> {
        guard
            let urlComponents = URLComponents(string: "https://query1.finance.yahoo.com/v7/finance/download/\(ticker)?period1=\(pastEpoch)&period2=\(futureEpoch)&interval=1d&events=history")
            else { preconditionFailure("Can't create url components...") }

        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        print("{TEST} \(url)")
        
        return session
                .dataTaskPublisher(for: url)
                .compactMap { (data, response) -> [StockData]? in
                    
                    if let content = String(data: data, encoding: .utf8){
                        return self.parseCSV(ticker: ticker, content: content)
                    } else {
                        return nil
                    }
                
                }.eraseToAnyPublisher()
//        return session
//            .dataTaskPublisher(for: url)
//            .map { String(data: data, encoding: .utf8) }
//            .decode(type: SearchResponse.self, decoder: decoder)
//            .map { $0.items }
//            .eraseToAnyPublisher()
    }
    
    func parseCSV (
        ticker: String,
        content: String)
        -> [StockData]? {

       // Load the CSV file and parse it
        let delimiter = ","
        var items:[StockData]? = []

        let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]

        for line in lines {
            
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
                }

                if  values.count > 0,//Double(values[0]),
                    let open = Double(values[1]),
                    let high = Double(values[2]),
                    let low = Double(values[3]),
                    let close = Double(values[4]),
                    let adjClose = Double(values[5]),
                    let volume = Double(values[6]) {

                    let item: StockData = StockData.init(
                        symbolName: ticker,
                        dateData: .init(values[0]),
                        open:open,
                        high:high,
                        low:low,
                        close:close,
                        adjClose:adjClose,
                        volume: volume)

                    // Put the values into the tuple and add it to the items array

                    items?.append(item)
                }
            }
        }

        return items
    }
}
