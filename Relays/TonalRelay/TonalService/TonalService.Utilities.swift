//
//  TonalService.SocialUtilities.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//

import Foundation

struct TonalUtilities {
    struct Social {
        public static func getTickers(_ text: String) -> [String] {
            let regex = re.compile("[$][A-Za-z][\\S]*")
            let found = regex.findall(text)
            return found
        }
        
        public static func getLinks(_ text: String) -> [String] {
            let types: NSTextCheckingResult.CheckingType = .link

            let detector = try? NSDataDetector(types: types.rawValue)

            guard let detect = detector else {
               return []
            }

            let matches = detect.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))

            return matches.compactMap { $0.url?.absoluteString }
        }
    }
    
    struct Models {
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
                rangeDates = range.dates.sorted(by: { $0.compare($1) == .orderedAscending })
                let objects = range.objects.sortDesc
                let dates = range.datesExpanded
                for item in objects {
                    var pocket: Pocket = .init(date: item.date, sentiment: [])
                    
                    let shiftedSentimentDate = item.sentimentDate
                    let possibles = Array(sentiments.keys).filter({ shiftedSentimentDate.compare($0) == .orderedDescending })
                    
                    for possible in possibles {
                        guard !dates.contains(possible.advanced(by: 1)) else {
                            break
                        }
                        
                        if let sentiment = sentiments[possible] {
                            pocket.sentiment.append(sentiment)
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
                \(pockets.map { $0.date.asString })
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
