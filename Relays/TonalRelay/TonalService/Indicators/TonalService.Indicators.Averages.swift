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
    
    var avgVolumePreviousDay: Double {
        history.suffix(history.count-1).map { $0.volumeValue }.reduce(0, +) / history.count.asDouble
    }
    
    var vwa: Double {
        security.volumeValue / avgVolume
    }
    
    var vwaPreviousDay: Double {
        (history.first ?? security).volumeValue / avgVolumePreviousDay
    }
    
    func sma(_ days: Int = 24) -> Double {
        let prefix = history.prefix(days)
        
        if prefix.count == days {
            return prefix.map { $0.dayAverage }.reduce(0, +) / days.asDouble
        } else {
            return prefix.map { $0.dayAverage }.reduce(0, +) / prefix.count.asDouble
        }
    }
    
    func smaWA(_ days: Int = 24) -> Double {
        security.lastValue / sma(days)
    }
}

extension Security {
    var dayAverage: Double {
        return (self.highValue + self.lowValue) / 2
    }
}

extension TonalServiceModels.Indicators {
    var averagesToString: String {
        """
        Reference: \(history.first?.date.asString ?? "error")
        avgMomentum: \(avgMomentum)
        avgVolatility: \(avgVolatility)
        avgVolVolatility: \(avgVolVolatility)
        avgVolume: \(avgVolume)
        vwa: \(vwa)
        sma20: \(sma())
        sma24: \(sma(24))
        smaWA24: \(smaWA())
        sma200: \(sma(200))
        """
    }
}
