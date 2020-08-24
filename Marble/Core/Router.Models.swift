//
//  Backend.Models.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/22/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import Firebase

//MARK: Backend
extension ServiceCenter.BackendService {
    public enum Route: String {
        case global = "global/"
        case users = "users/"
        case stocks = "stocks/"
        case stockSearches = "stocks/searches"
        case stockPredictions = "stocks/predictions"
        case globalStocksFreeRotation = "global/stocks/freeRotation"
        case disclaimerUpcoming = "disclaimer/upcoming"
    }
}

extension Dictionary where Key == AnyHashable, Value: Any {
    public var backendModel: [[AnyHashable: Any]]? {
        
        if let models = Array(self.values) as? [[AnyHashable: Any]] {
            return models.compactMap { $0["model"] as? [AnyHashable: Any] }
        }
        
        return nil
    }
}

public protocol BackendModel {
    var backendModel: [AnyHashable: Any] { get }
}

extension NSObject: BackendModel {
    public typealias T = NSObject
    
    public var backendModel: [AnyHashable: Any] {
        let m = Mirror(reflecting: self)
        
        let values = m.children.reduce([AnyHashable: Any]()) {
            (dict, child) -> [AnyHashable: Any] in
            var dict = dict
            var value: Any = child.value
            
            switch child.value
            {
            case is NSNumber, is NSString, is NSDictionary: break
            case is NSArray:
                var convertedDictionary: [AnyHashable:Any] = [:]
                if let childObj = child.value as? [NSObject] {
                    let convertedValues = childObj.compactMap { $0.backendModel }
                    convertedDictionary["dict"] = convertedValues
                    value = convertedDictionary
                    print("{TEST} \(convertedValues)")
                }
            default:
                if let childObj = child.value as? NSObject {
                    value = childObj.backendModel
                }
            }
            
            dict[child.label ?? "error-\(UUID().uuidString)"] = value
            
            return dict
        }
        
        return [
            "\(Int(Date().timeIntervalSince1970))" : ["model":values]
        ]
    }
}

extension BackendModel where Self: Codable {
    public static func initialize(from model: [AnyHashable: Any]) -> Self? {
        guard let data = try? JSONSerialization.data(
            withJSONObject: model,
            options: .prettyPrinted) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(Self.self, from: data)
    }
}
