//
//  StockDateData.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/19/20.
//

import Foundation

public class StockDateData: NSObject, Codable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    var asString: String
    var asDate: Date?
    var isOpen: Bool
    
    public var dateComponents: (year: Int, month: Int, day: Int) {
        let day = Calendar.nyCalendar.component(.day, from: asDate ?? Date())
        let month = Calendar.nyCalendar.component(.month, from: asDate ?? Date())
        let year = Calendar.nyCalendar.component(.year, from: asDate ?? Date())
        return (year, month, day)
    }
    
    public init(
        date: Date?,
        isOpen: Bool,
        dateAsString: String) {
        self.asDate = date
        self.asString = dateAsString
        self.isOpen = isOpen
    }
    
    public init(_ dateAsString: String) {
        self.asDate = dateAsString.asDate()
        self.asString = dateAsString
        self.isOpen = true
    }
    
    public required convenience init?(coder: NSCoder) {
        let asString = coder.decodeObject(forKey: "asString") as! String
        let asDate = coder.decodeObject(forKey: "asDate") as? Date
        let isOpen = coder.decodeObject(forKey: "isOpen") as? Bool

        self.init(
            date: asDate,
            isOpen: isOpen ?? true,
            dateAsString: asString)
    }

    public func encode(with coder: NSCoder){
        coder.encode(asString, forKey: "asString")
        coder.encode(asDate, forKey: "asDate")
        coder.encode(isOpen, forKey: "isOpen")
    }
}

extension Array where Element == StockDateData {
    var descending: [StockDateData] {
        return self.sorted(by: { ($0.asDate ?? Date())
            .compare(($1.asDate ?? Date())) == .orderedDescending })
    }
}
