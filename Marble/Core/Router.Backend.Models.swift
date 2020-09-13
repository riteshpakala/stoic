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
        case general = "general/"
        case global = "global/"
        case users = "users/"
        case stocks = "stocks/"
        case stockSearches = "stocks/searches"
        case stockPredictions = "stocks/predictions"
        case globalStocksFreeRotation = "global/stocks/freeRotation"
        case disclaimerUpcoming = "disclaimer/upcoming"
        case announcementUpcoming = "announcement/upcoming"
        case announcementWelcome = "announcement/welcome"
        
        public enum Permission {
            case update
            case overwrite
            case set
        }
        
        public enum Query {
            case limitFirst(UInt)
            case limitLast(UInt)
        }
    }
}

public struct CustomCodingKey: CodingKey {
    
    public var stringValue: String
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public var intValue: Int?
    
    public init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    public static var model: CustomCodingKey {
        return CustomCodingKey.init(stringValue: "model")!
    }
}

extension KeyedDecodingContainer {
    func nested(
        forTime: String, of key: K) -> KeyedDecodingContainer<CustomCodingKey>? {
        
        
        
        guard let nestedContainer = try? self.nestedContainer(
            keyedBy: CustomCodingKey.self,
            forKey: key) else {
                
            print("f2");return nil
        }
        
        guard let timeKey = CustomCodingKey.init(
            stringValue: forTime) else { print("f1"); return nil }
        
        guard let nestedContainerModel = try? nestedContainer.nestedContainer(
            keyedBy: CustomCodingKey.self,
            forKey: timeKey) else {
                
            print("f3");return nil
        }
        
        return nestedContainerModel
    }
}

extension Dictionary where Key == AnyHashable, Value: Any {
    public var backendModel: [[AnyHashable: Any]]? {
        
        if let models = Array(self.values) as? [[AnyHashable: Any]] {
            var modelsToReturn = models.compactMap { $0["model"] as? [AnyHashable: Any] }
            for i in 0..<modelsToReturn.count {
                modelsToReturn[i]["time"] = Array(self.keys)[i]
            }
            if modelsToReturn.isEmpty {
                let modelLevel1 = models.compactMap { $0.backendModel }
                
                return modelLevel1.first
            } else {
                return modelsToReturn
            }
        }
        
        return nil
    }
}

extension Dictionary where Key == String, Value: Any {
    public func decode() -> [[AnyHashable: Any]] {
        self.values.compactMap {
            if let nextItem = $0 as? [[AnyHashable: Any]] {
                let validated: [[AnyHashable: Any]] = nextItem.compactMap { (Array($0.values).first as? [AnyHashable: Any]) }
                let validatedModels: [[AnyHashable: Any]] = validated.compactMap { $0["model"] as? [AnyHashable: Any] }
                
                return validatedModels.first
            } else {
                return nil
            }
        }
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

//MARK: KeyedContainer Helpers
extension KeyedDecodingContainer {

    func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: CustomCodingKey.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {

    mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {

        let nestedContainer = try self.nestedContainer(keyedBy: CustomCodingKey.self)
        return try nestedContainer.decode(type)
    }
}
