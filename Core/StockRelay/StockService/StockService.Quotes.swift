//
//  StockService.Movers.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//

import Foundation
import Combine

extension StockService {
    public func getQuotes(symbols: String) -> AnyPublisher<[StockServiceModels.Quotes], URLError> {
        guard
            var urlComponents = URLComponents(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-quotes")
            else { preconditionFailure("Can't create url components...") }
        
        
        
        let regionQuery: URLQueryItem = .init(name: "region", value: "US")
        let symbolsQuery: URLQueryItem = .init(name: "symbols", value: symbols)
        
        urlComponents.queryItems = [regionQuery, symbolsQuery]
        
        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        print("{TEST} \(url)")
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        let headers = [
            "x-rapidapi-key": "0c0e4882d8mshff3f1b457562c64p12c681jsn48b2eeb37946",
            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
        ]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let decoder = JSONDecoder()
        return session
                .dataTaskPublisher(for: request)
                .compactMap { (data, response) -> [StockServiceModels.Quotes]? in
                    
                    let movers: StockServiceModels.Quotes?
                    do {
                        
                        movers = try decoder.decode(StockServiceModels.Quotes.self, from: data)
                    } catch let error {
                        movers = nil
                        print("{TEST} \(error)")
                    }
                    
                    return movers != nil ? [movers!] : nil
                
                }.eraseToAnyPublisher()
    }
}

extension StockServiceModels {
    public struct Quotes: Codable {
        public struct Keys {
            public static var topVolume: String = "MOST_ACTIVES"
            public static var gainers: String = "DAY_GAINERS"
            public static var losers: String = "DAY_LOSERS"
        }
        
        public struct QuoteResponse: Codable {
            public struct QuoteResult: Codable {
                let language: String
                let region: String
                let quoteType: String
                let quoteSourceName: String
                let triggerable: Bool
                let quoteSummary: QuoteSummary
                let currency: String
                let fiftyTwoWeekLowChange: Double?
                let fiftyTwoWeekLowChangePercent: Double?
                let fiftyTwoWeekRange: String?
                let fiftyTwoWeekHighChange: Double?
                let fiftyTwoWeekHighChangePercent: Double?
                let fiftyTwoWeekLow: Double?
                let fiftyTwoWeekHigh: Double?
                let exDividendDate: Int64?
                let earningsTimestamp: Int64?
                let earningsTimestampStart: Int64?
                let earningsTimestampEnd: Int64?
                let trailingPE: Double?
                let pegRatio: Double?
                let dividendsPerShare: Double?
                let revenue: Int64?
                let priceToSales: Double?
                let marketState: String?
                let epsTrailingTwelveMonths: Double?
                let epsForward: Double?
                let epsCurrentYear: Double?
                let epsNextQuarter: Double?
                let priceEpsCurrentYear: Double?
                let priceEpsNextQuarter: Double?
                let sharesOutstanding: Int64?
                let bookValue: Double?
                let fiftyDayAverage: Double
                let fiftyDayAverageChange: Double
                let fiftyDayAverageChangePercent: Double
                let twoHundredDayAverage: Double
                let twoHundredDayAverageChange: Double
                let twoHundredDayAverageChangePercent: Double
                let marketCap: Int64
                let forwardPE: Double?
                let priceToBook: Double?
                let sourceInterval: Int64?
                let exchangeDataDelayedBy: Int64?
                let exchangeTimezoneName: String
                let exchangeTimezoneShortName: String
                let pageViews: PageViews?
                let gmtOffSetMilliseconds: Int64?
                let esgPopulated: Bool?
                let tradeable: Bool
                let firstTradeDateMilliseconds: Int64?
                let priceHint: Int
                let totalCash: Int64?
                let floatShares: Int64?
                let ebitda: Int64?
                let shortRatio: Double?
                let preMarketChange: Double?
                let preMarketChangePercent: Double?
                let preMarketTime: Int64?
                let targetPriceHigh: Double?
                let targetPriceLow: Double?
                let targetPriceMedian: Double?
                let preMarketPrice: Double?
                let heldPercentInsiders: Double?
                let heldPercentInstitutions: Double?
                let postMarketChangePercent: Double?
                let postMarketTime: Int64?
                let postMarketPrice: Double?
                let postMarketChange: Double?
                let regularMarketChange: Double?
                let regularMarketChangePercent: Double?
                let regularMarketTime: Int64?
                let regularMarketPrice: Double?
                let regularMarketDayHigh: Double?
                let regularMarketDayRange: String?
                let regularMarketDayLow: Double?
                let regularMarketVolume: Int64?
                let sharesShort: Int64?
                let sharesShortPrevMonth: Int64?
                let shortPercentFloat: Double?
                let bid: Double?
                let ask: Double?
                let bidSize: Int64?
                let askSize: Int64?
                let exchange: String
                let market: String
                let messageBoardId: String?
                let fullExchangeName: String
                let shortName: String
                let longName: String
                let regularMarketOpen: Double?
                let averageDailyVolume3Month: Int64?
                let averageDailyVolume10Day: Int64?
                let beta: Double?
                let components: [String]?
                let symbol: String
            }
            
            let result: [QuoteResult]
            let error: String?
        }
        
        public struct QuoteSummary: Codable {
            public struct Earnings: Codable {
                public struct EarningsChart: Codable {
                    public struct Quarterly: Codable {
                        let date: String
                        let actual: Double
                        let estimate: Double
                    }
                    
                    let quarterly: [Quarterly]
                    let currentQuarterEstimate: Double
                    let currentQuarterEstimateDate: String
                    let currentQuarterEstimateYear: Int
                    let earningsDate: [Int64]
                }
                
                public struct FinancialsChart: Codable {
                    public struct Yearly: Codable {
                        let date: Int
                        let revenue: Int64
                        let earnings: Int64
                    }
                    
                    public struct Quarterly: Codable {
                        let date: String
                        let revenue: Int64
                        let earnings: Int64
                    }
                    
                    let yearly: [Yearly]
                    let quarterly: [Quarterly]
                }
                
                let maxAge: Int
                let earningsChart: EarningsChart
                let financialsChart: FinancialsChart
                let financialCurrency: String
            }
        }
        
        public struct PageViews: Codable {
            let midTermTrend: String
            let longTermTrend: String
            let shortTermTrend: String
        }
        
        
        
        let quoteResponse: QuoteResponse
    }
}
