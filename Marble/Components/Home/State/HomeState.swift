//
//  HomeViewState.swift
//  Marble
//
//  Created by Ritesh Pakala on 5/14/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public class HomeState: State {
    var test = 0
    
    var sentimentClassifier: SentimentClassifier = .init()
    var sentimentPolarity: SentimentPolarity = .init()
}
