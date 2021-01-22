//
//  Detail.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation
import GraniteUI
import SwiftUI

class Detail: ObservableObject {
    var stage: SecurityDetailStage = .none {
        didSet {
            if stage == .none {
                quote = nil
            }
        }
    }
    
    var holdings: HoldingsState = .init( .init(.init(.securityDetail(.expanded(.init(object: nil))))), type: .standalone)
    
    var quote: Quote? = nil {
        didSet {
            if let quote = quote {
                stage = .loaded
                indicators = TonalServiceModels.Indicators.init(with: quote)
            }
        }
    }
    
    var tonalStage: TonalDetailStage = .none 
    var model: TonalModel?
    var slider: SentimentSliderState = .init(.neutral, date: .today)
    
    var indicators: TonalServiceModels.Indicators?
}
