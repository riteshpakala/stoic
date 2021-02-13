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
    var tonalStage: TonalDetailStage = .none
    var model: TonalModel? = nil {
        didSet {
            modelID = ""
        }
    }
    var modelID: String = "" {
        didSet {
            model = nil
        }
    }
    var slider: SentimentSliderState = .init(.neutral, date: .today)
}
