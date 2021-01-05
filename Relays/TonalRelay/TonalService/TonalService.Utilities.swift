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
                [indicators.change]
            }

            public var description: String {
                let desc: String =
                    """
                    💽💽💽💽💽💽💽💽💽💽💽💽💽
                    '''''''''''''''''''''''''''''
                    [ Security Data Set - \(security.securityType) - \(security.date.asString) ]
                    Value: \(security.lastValue)
                    Pair: \(indicators.basePair.toString)
                    Change: \(indicators.change)
                    \(indicators.averagesToString)
                    \(sentiment.asString)
                    '''''''''''''''''''''''''''''
                    💽
                    """
                return desc
            }
        }
    }
}
