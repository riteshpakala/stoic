//
//  StrategyTestable.swift
//  stoic
//
//  Created by Ritesh Pakala on 3/8/21.
//

import Foundation

extension Strategy.Investments.Item {
    public class Meta: Archiveable {
        let initial: Change
        
        //Changes after the initial
        var future: [Change] = []
        
        //Changes before the initial
        var past: [Change] = []
        
        var aggregate: [Change] {
            past + [initial] + future
        }
        
        var predictions: [Change : TonalPrediction] = [:]
        var tones: [Change : TonalPrediction.Tone] = [:]
        var models: [Change : String] = [:]
        
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
        
        public init(initial: Change, past: [Change] = [], future: [Change] = []) {
            
            self.initial = initial
            self.past = past
            self.future = future
        }
        
        // Encoding
        enum CodingKeys: String, CodingKey {
            case initial
            case future
            case past
            case models
        }
        
        required public convenience init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let initial: Change = try container.decode(Change.self, forKey: .initial)
            let future: [Change] = try container.decode([Change].self, forKey: .future)
            let past: [Change] = try container.decode([Change].self, forKey: .past)
            let models: [Change : String] = try container.decode([Change : String].self, forKey: .past)
            
            self.init(initial: initial,
                      past: past,
                      future: future)
            
            
            self.past = past.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
            self.future = future.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
            self.models = models
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(initial, forKey: .initial)
            try container.encode(future, forKey: .future)
            try container.encode(past, forKey: .past)
            try container.encode(models, forKey: .models)
        }
    }
    
    func toneExists(_ change: Change) -> Bool {
        self.meta.tones[change] != nil
    }
}

extension Strategy.Investments.Item.Meta {

}
