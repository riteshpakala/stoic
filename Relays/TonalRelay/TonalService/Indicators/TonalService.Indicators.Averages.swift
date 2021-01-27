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
    
    func slicedVolatilities(_ days: Int = 4) -> [Volatility] {
        Array(volatilities.prefix(days))
    }
    
    //MARK: -- Momentum
    func avgMomentum(_ days: Int = 120) -> Double {
        slicedVolatilities(days).map { $0.momentum }.reduce(0, +) / days.asDouble
    }
    
    func avgVolMomentum(_ days: Int = 120) -> Double {
        slicedVolatilities(days).map { $0.volMomentum }.reduce(0, +) / days.asDouble
    }
    
    //MARK: -- Volatility
    func avgVolatility(_ days: Int = 12) -> Double {
        slicedVolatilities(days).map { $0.volatility }.reduce(0, +) / days.asDouble
    }
    
    func avgVolVolatility(_ days: Int = 12) -> Double {
        slicedVolatilities(days).map { $0.volumeVolatiliy }.reduce(0, +) / days.asDouble
    }
    
    //MARK: -- Change
    func avgChange(_ days: Int = 4) -> Double {
        slicedVolatilities(days).map { $0.change }.reduce(0, +) / days.asDouble
    }
    
    //MARK: -- Volume
    func avgVolChange(_ days: Int = 4) -> Double {
        slicedVolatilities(days).map { $0.volumeChange }.reduce(0, +) / days.asDouble
    }
    
    func avgVolume(_ days: Int = 12) -> Double {
        history.prefix(days).map { $0.volumeValue }.reduce(0, +) / days.asDouble
    }
    
    func avgVolumePreviousDay(_ days: Int = 24) -> Double {
        history.suffix(history.count-1).prefix(days).map { $0.volumeValue }.reduce(0, +) / days.asDouble
    }
    
    func vwa(_ days: Int = 12) -> Double {
        security.volumeValue / avgVolume(days)
    }
    
    //MARK: -- SMA
    func sma(_ days: Int = 12) -> Double {
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
    
    //MARK: -- EMA
    func ema(_ days: Int = 12) -> Double {
        let firstOfHistoricalSecurities = history.first ?? security
        
        let indicatorsOfThePast = TonalServiceModels.Indicators.init(firstOfHistoricalSecurities, with: self.quote)
        
        /**
         
         EMA=(closing price − previous day’s EMA)× smoothing constant as a decimal + previous day’s EMA
                    "previous day's EMA  == previous day's SMA".... lol
         
         
                smoothing constant = 2/days + 1 aka 2/time periods + 1
         
            
         */
        
        let prevEMA_aka_SMA = indicatorsOfThePast.sma(days)
        let x1 = firstOfHistoricalSecurities.lastValue - prevEMA_aka_SMA
        let x2 = 2/(days + 1)
        let y1 = prevEMA_aka_SMA
        
        let emaValue = (x1 * x2) + y1
        
        return emaValue
    }
    
    func emaWA(_ days: Int = 12) -> Double {
        security.lastValue / ema(days)
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
        %%%%%%%%%%%%%
        Comparing To: \(history.first?.date.asString ?? "error")
        avgMomentum: \(avgMomentum())
        avgVolatility: \(avgVolatility())
        avgChange: \(avgChange())
        avgVolume: \(avgVolume())
        avgVolMomentum: \(avgVolMomentum())
        avgVolVolatility: \(avgVolVolatility())
        avgVolumeChange: \(avgVolChange())
        vwa: \(vwa())
        sma12: \(sma(12))
        sma20: \(sma(20))
        sma24: \(sma(24))
        smaWA24: \(smaWA())
        sma200: \(sma(200))
        ema: \(ema())
        emaWA: \(emaWA())
        """
    }
}
