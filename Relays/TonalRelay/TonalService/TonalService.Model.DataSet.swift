//
//  TonalService.Model.DataSet.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation

extension TonalService {
    struct AI {
        struct Models {
            public struct Settings {
                static let inDim: Int = 8
                static let outDim: Int = 1
            }
            
            struct Bucket {
                struct Pocket {
                    let date: Date
                    var sentiment: [SentimentOutput]
                    
                    var avg: SentimentOutput {
                        sentiment.average(sentiment.map { $0.date }.max() ?? date)
                    }
                }
                var pockets: [Pocket] = []
                var rangeDates: [Date] = []
                public init(sentiments: [Date: SentimentOutput], range: TonalRange) {
                    rangeDates = range.dates.sortAsc
                    let objects = range.objects.sortAsc
                    var sentimentDates = Array(sentiments.keys).sortDesc
            
                    for item in objects {
                        var pocket: Pocket = .init(date: item.date, sentiment: [])
                        
                        let shiftedSentimentDate = item.sentimentDate
                        let possibles = sentimentDates.filterBelow(shiftedSentimentDate)
                        
                        
                        for possible in possibles {
                            if let sentiment = sentiments[possible] {
                                pocket.sentiment.append(sentiment)
                                
                                if let index = sentimentDates.firstIndex(of: possible) {
                                    sentimentDates.remove(at: index)
                                }
                            }
                        }
                        
                        if pocket.sentiment.isNotEmpty {
                            pockets.append(pocket)
                        }
                    }
                    
                }
                
                var isValid: Bool {
                    pockets.count == rangeDates.count
                }
                
                var asString: String {
                    """
                    \(pockets.map { "\($0.date.asString) ~ \($0.sentiment.count)" })
                    """
                }
            }
            
            struct DataSet {
                let security: Security
                let sentiment: SentimentOutput
                
                var indicators: TonalServiceModels.Indicators
                
                let modelType: TonalModels.ModelType
                let predicting: Bool

                init(
                    _ security: Security,
                    _ sentiment: SentimentOutput,
                    quote: Quote,
                    modelType: TonalModels.ModelType = .none,
                    predicting: Bool = false) {

                    self.security = security
                    self.sentiment = sentiment
                    self.indicators = .init(security, with: quote)
                    self.modelType = modelType
                    self.predicting = predicting
                }

                public var asArray: [Double] {
                    [
                        indicators.avgMomentum,
                        indicators.avgVolatility,
                        indicators.vwa,
                        indicators.smaWA(),
                        sentiment.pos,
                        sentiment.neg,
                        sentiment.neu
                    ]
                }

                public var inDim: Int {
                    asArray.count
                }

                public var outDim: Int {
                    output.count
                }

                public var output: [Double] {
                    [security.lastValue]
                }

                public var description: String {
                    let desc: String =
                        """
                        💽💽💽💽💽💽💽💽💽💽💽💽💽
                        '''''''''''''''''''''''''''''
                        [ Security Data Set - \(security.securityType) - \(security.date.asString) ]
                        Value: \(security.lastValue)
                        Pair: \(indicators.basePair.toString)
                        Change: \(security.changePercentValue)
                        \(indicators.averagesToString)
                        \(sentiment.asString)
                        '''''''''''''''''''''''''''''
                        💽
                        """
                    return desc
                }
                
                public var inputDescription: String {
                    let desc: String =
                        """
                        💽💽💽💽💽💽💽💽💽💽💽💽💽
                        '''''''''''''''''''''''''''''
                        [ Security Data Set - \(security.securityType)  ]
                        
                        \(indicators.basePair.base.date.asString) ----
                        \(indicators.averagesToString)
                        \(sentiment.description)
                        '''''''''''''''''''''''''''''
                        💽
                        """
                    return desc
                }
            }
        }

    }
}
