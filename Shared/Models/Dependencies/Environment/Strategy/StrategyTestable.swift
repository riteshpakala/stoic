//
//  StrategyTestable.swift
//  stoic
//
//  Created by Ritesh Pakala on 3/8/21.
//

import Foundation

extension Strategy.Investments.Item {
    
    class Testable {
        var pastChanges: [Change] = []
        var predictions: [Change : TonalPrediction] = [:]
        var tones: [Change : TonalPrediction.Tone] = [:]
        var modelID: String = ""
        
        var noModel: Bool {
            print("{TEST} \(modelID)")
            return modelID.isEmpty
        }
        
        func getTone(forChange change: Change) -> TonalPrediction.Tone? {
            if let tone = tones[change] {
                return tone
            } else {
                return nil
            }
        }
        
        func update(_ prediction: TonalPrediction, change: Change) {
            predictions[change] = prediction
            tones[change] = .init(prediction,
                                  context: .purchased)
        }
        
        var modelIDDisplay: String {
            (self.modelID.components(separatedBy: "-").last ?? self.modelID).lowercased()
        }
        
    }
    
    func toneExists(_ change: Change) -> Bool {
        self.testable.tones[change] != nil
    }
}
