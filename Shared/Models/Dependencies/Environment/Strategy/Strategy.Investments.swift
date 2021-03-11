//
//  Strategy.Investments.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/10/21.
//

import Foundation
import CoreGraphics
import GraniteUI
import SwiftUI

extension Strategy {
    public class Investments: Archiveable {
        
        var items: [Item]
        
        public init(items: [Item] = []) {
            self.items = items
        }
        
        enum CodingKeys: String, CodingKey {
            case items
        }
        
        required public convenience init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let items: [Item] = try container.decode([Item].self, forKey: .items)
            
            self.init(items: items)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(items, forKey: .items)
        }
        
        public static var empty: Strategy.Investments {
            .init()
        }
    }
    
    public static var empty: Strategy {
        .init([], "", .today, .empty)
    }
}
