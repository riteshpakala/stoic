//
//  TonalService.Indicators.Averages.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation

extension TonalServiceModels.Indicators {
    var volatilities: [Volatility] {
        historyPaired.map { $0.volatility }
    }
    
    var avgMomentum: Double {
        volatilities.map { $0.momentum }.reduce(0, +) / history.count.asDouble
    }
    
    var avgVolatility: Double {
        volatilities.map { $0.volatility }.reduce(0, +) / history.count.asDouble
    }
    
    var avgVolVolatility: Double {
        volatilities.map { $0.volumeVolatiliy }.reduce(0, +) / history.count.asDouble
    }
    
    var avgVolume: Double {
        history.map { $0.volumeValue }.reduce(0, +) / history.count.asDouble
    }
    
    func sma(_ days: Int = 20) -> Double {
        let prefix = history.prefix(days)
        
        if prefix.count == days {
            return prefix.map { $0.dayAverage }.reduce(0, +) / days.asDouble
        } else {
            return prefix.map { $0.dayAverage }.reduce(0, +) / prefix.count.asDouble
        }
    }
}

extension TonalServiceModels.Indicators {
    var averagesToString: String {
        """
        avgMomentum: \(avgMomentum)
        avgVolatility: \(avgVolatility)
        avgVolVolatility: \(avgVolVolatility)
        avgVolume: \(avgVolume)
        sma20: \(sma())
        sma24: \(sma(24))
        sma200: \(sma(200))
        """
    }
}

extension Security {
    var dayAverage: Double {
        (self.highValue + self.lowValue) / 2
    }
}
