//
//  StockKitState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

struct PredictionRules {
    var days: Int = 4
    var maxDays: Int = 12
    var baseLangCode: String = "en"
}

public class StockKitState: State {
    var rules: PredictionRules = .init()
    
    var yahooFinanceAPIHistoryKey: String = "1591833600"
    
    var consumerKey: String = "NuSY3LhZ9N3grMdMR9J0nJnWS"
    var consumerSecret: String = "uzWi6uyTrIu2gzkzgKgLgilm7iukuaxzW4NGvCN9XSY1a2r6eo"
    lazy var swifter: Swifter = {
        Swifter(
            consumerKey: consumerKey,
            consumerSecret: consumerSecret)
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = Calendar.nyTimezone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    lazy var timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = Calendar.nyTimezone
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }()
    
    var validTradingDays: [StockDateData]? = nil
    @objc dynamic var nextValidTradingDay: StockDateData? = nil
    
    
    var currentDate: Date {
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.nyTimezone
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        let nyDateAsString = formatter.string(from: Date())

        return formatter.date(from: nyDateAsString) ?? Date()
    }
    var currentDateAsString: String {
        return dateAsString(date: currentDate)
    }
    var currentTime: (hour: Int, minute: Int, seconds: Int) {
        let time = timeFormatter.string(from: currentDate)
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
    var date: Date? {
        let sortedTradingDays = validTradingDays?.sorted(
            by:  { ($0.asDate ?? Date())
                .compare(($1.asDate ?? Date())) == .orderedDescending } )
        
        return sortedTradingDays?.last?.asDate
    }
    
    var dateTargetAsString: String? {
        guard let date = date else {
            return nil
        }
        
        return dateAsString(date: date)
    }
    
    var currentDateComponents: (year: Int, month: Int, day: Int) {
        return dateComponents(fromDate: currentDate)
    }
    
    init(
        consumerKey: String? = nil,
        consumerSecret: String? = nil) {
        
        if  let key = consumerKey,
            let secret = consumerSecret {
            
            self.consumerKey = key
            self.consumerSecret = secret
        }
        
        super.init()
        
        
        yahooFinanceAPIHistoryKey = "\(Int(currentDate.timeIntervalSince1970))"
        
       
        
        print("{TEST} \(currentDateComponents)")
        print("{TEST} \(yahooFinanceAPIHistoryKey)")
    }
    
    func dateAsString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func dateComponents(fromDate date: Date) -> (year: Int, month: Int, day: Int) {
        let calendar = Calendar.nyCalendar

        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        return(year, month, day)
    }
    
    func advanceDate1Day(date: Date, value: Int = 1) -> Date? {
        return Calendar.nyCalendar.date(byAdding: .day, value: value, to: date)
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
}
