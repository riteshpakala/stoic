//
//  Date.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation
import CoreData

extension String {
    func asDate() -> Date? {
        return Calendar.nyDateFormatter.date(from: self)
    }
}

extension Date {
    var simple: Date {
        self.asString.asDate() ?? self
    }
    var asString: String {
        return Calendar.nyDateFormatter.string(from: self)
    }
    
    func advanceDate(value: Int = 1) -> Date {
        return Calendar.nyCalendar.date(byAdding: .day, value: value, to: self) ?? self
    }
    
    public static var today: Date {
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.nyTimezone
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        
        let date: Date = Date()
        
        let nyDateAsString = formatter.string(from: date)

        return formatter.date(from: nyDateAsString) ?? date
        
    }
    
    func dateComponents() -> (year: Int, month: Int, day: Int) {
        let calendar = Calendar.nyCalendar

        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        
        return(year, month, day)
    }
    func timeComponents() -> (hour: Int, minute: Int, seconds: Int) {
        let time = Calendar.nyTimeFormatter.string(from: self)
        let components = time.components(separatedBy: ":")
        var hour: Int = 0
        var minute: Int = 0
        var seconds: Int = 0
        if components.count == 3 {
            hour = Int(components[0]) ?? 0
            minute = Int(components[1]) ?? 0
            seconds = Int(components[2]) ?? 0
        }
        return (hour, minute, seconds)
    }
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}

extension Array where Element == Date {
    public var sortAsc: [Date] {
        self.sorted(by: { $0.compare($1) == .orderedAscending })
    }
    
    public var sortDesc: [Date] {
        self.sorted(by: { $0.compare($1) == .orderedDescending })
    }
    
    public func filterAbove(_ date: Date) -> [Date] {
        return self.filter( { date.compare($0) == .orderedAscending })
    }
    
    public func filterBelow(_ date: Date) -> [Date] {
        return self.filter( { date.compare($0) == .orderedDescending })
    }
}

//MARK: -- Traversal WIP
extension Date {
    func isIn(range: TonalRange) -> Bool {
        let dates = range.datesExpanded
        guard let max = dates.max(),
              let min = dates.min() else {
            return false
        }
        
        return min.isLessOrEqual(to: self) && max.isGreaterOrEqual(to: self)
    }
    
    func isLessOrEqual(to: Date) -> Bool {
        return to.compare(self) == .orderedDescending || self.compare(to) == .orderedSame
    }
    
    func isGreaterOrEqual(to: Date) -> Bool {
        return to.compare(self) == .orderedDescending || self.compare(to) == .orderedSame
    }
}


extension Array where Element == Security {
    var dates: [Date] {
        self.map { $0.date }
    }
}

extension Array where Element == SecurityObject {
    var dates: [Date] {
        self.map { $0.date }
    }
}

extension Calendar {
    static var nyTimezone: TimeZone {
        return TimeZone(identifier: "America/New_York") ?? .current
    }
    
    static var nyCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = Calendar.nyTimezone
        
        return calendar
    }
    
    static var nyDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = Calendar.nyTimezone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    static var nyTimeFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = Calendar.nyTimezone
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }
}

extension Double {
    func date() -> Date {
        let unixDate: Double = self
        let date = Date.init(timeIntervalSince1970: TimeInterval(unixDate))
        return date
    }
}

