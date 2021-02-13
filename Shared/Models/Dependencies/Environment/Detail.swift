//
//  Detail.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation
import GraniteUI
import SwiftUI

class Detail {
//    var holdings: HoldingsState = .init( .init(.init(.securityDetail(.expanded(.init(object: nil))))), type: .standalone)
    
    var tonalStage: TonalDetailStage = .none 
    var model: TonalModel?
    var slider: SentimentSliderState = .init(.neutral, date: .today)
    
    var indicators: TonalServiceModels.Indicators?
}
