//
//  TonalService.Indicators.Basic.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation

extension TonalServiceModels.Indicators {
    public struct Volatility {
        let paired: PairedSecurity
        
        var momentum: Double {
            paired.base.lastValue > paired.previous.lastValue ? 1 : -1
        }
        
        var volatility: Double {
            (paired.base.lastValue - paired.previous.lastValue) / 2
        }
        
        var change: Double {
            (paired.base.lastValue - paired.previous.lastValue) / paired.previous.lastValue
        }
        
        var volMomentum: Double {
            paired.base.volumeValue > paired.previous.volumeValue ? 1 : -1
        }
        
        var volumeVolatiliy: Double {
            (paired.base.volumeValue - paired.previous.volumeValue) / 2
        }
        
        var volumeChange: Double {
            (paired.base.volumeValue - paired.previous.volumeValue) / paired.previous.volumeValue
        }
    }
}
