//
//  StockKitState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

public struct PredictionRules {
    var days: Int = 7
    var maxDays: Int = 12
    var historicalDays: Int = 36
    var baseLangCode: String = "en"
    var tweets: Int = 1
    let marketCloseHour: Int = 16
    let rsiMaxHistorical: Int = 20
    
    public struct PredictionLevels {
        public static var sentimentLow: Int = 1
        public static var sentimentMed: Int = 4
        public static var sentimentHi: Int = 7
        
        public static var maxDaysLearnedLearned: Int = 12
        public static var minDaysLearnedLearned: Int = 1
    }
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
    
    var validTradingDays: [StockDateData]? = nil
    var validHistoricalTradingDays: [StockDateData]? = nil
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
        return currentDate.timeComponents()
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
        return currentDate.dateComponents()
    }
    
    init(
        predictionSentiment: String = "low",
        predictionDays: Int = 7,
        consumerKey: String? = nil,
        consumerSecret: String? = nil) {
        
        //TODO: Constants for strength levels
        if predictionSentiment == "med" {
            rules.tweets = PredictionRules.PredictionLevels.sentimentMed
        } else if predictionSentiment == "hi" {
            rules.tweets = PredictionRules.PredictionLevels.sentimentHi
        } else {
            rules.tweets = PredictionRules.PredictionLevels.sentimentLow
        }
        
        rules.days = predictionDays
        
        if  let key = consumerKey,
            let secret = consumerSecret {
            
            self.consumerKey = key
            self.consumerSecret = secret
        }
        
        super.init()
        
        yahooFinanceAPIHistoryKey = "\(Int(currentDate.timeIntervalSince1970))"
        
        print("{STOCKIT} \(rules.tweets)")
        print("{STOCKIT} \(rules.days)")
        print("{STOCKIT} \(currentDateComponents)")
        print("{STOCKIT} \(yahooFinanceAPIHistoryKey)")
    }
    
    func dateAsString(date: Date) -> String {
        return Calendar.nyDateFormatter.string(from: date)
    }
    
    func advanceDate1Day(date: Date, value: Int = 1) -> Date? {
        return Calendar.nyCalendar.date(byAdding: .day, value: value, to: date)
    }
}

extension String {
    func asDate() -> Date? {
        return Calendar.nyDateFormatter.date(from: self)
    }
}

extension Date {
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
