//
//  Detail.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation
import GraniteUI
import SwiftUI

public class DetailDependency: GraniteInjectable {
    var detail: Detail = .init()
}

class Detail {
    var tonalStage: TonalDetailStage = .none
    var model: TonalModel? = nil {
        didSet {
            guard modelID.isNotEmpty else { return }
            modelID = ""
        }
    }
    var modelID: String = "" {
        didSet {
            guard model != nil else { return }
            model = nil
        }
    }
    var slider: SentimentSliderState = .init(.neutral, date: .today)
}
