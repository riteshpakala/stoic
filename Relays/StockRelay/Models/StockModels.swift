//
//  StockModels.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/19/20.
//

import Foundation


extension String {
    func asDate() -> Date? {
        return Calendar.nyDateFormatter.date(from: self)
    }
}

extension Date {
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

//
//  StockKitUtilities.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/27/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

public struct StockKitUtils {
    static let inDim: Int = 6
    static let outDim: Int = 1
    
    static let Tolerance: Double = 10e-20
    public static func calculateRsi(_ closePrices: [Double]) -> Double
    {
        var sumGain: Double = 0;
        var sumLoss: Double = 0;
        for i in 1..<closePrices.count {
            let difference = closePrices[i] - closePrices[i - 1];
            if (difference >= 0)
            {
                sumGain += difference;
            }
            else
            {
                sumLoss -= difference;
            }
        }

        if (sumGain == 0) { return 0 }
        if (abs(sumLoss) < StockKitUtils.Tolerance) { return 100 }

        let relativeStrength = sumGain / sumLoss;

        return 100.0 - (100.0 / (1 + relativeStrength));
    }
}

public class StockKitModels: Archiveable {
    
    public static let engine: String = "david.v00.01.10"
    public enum ModelType: Int, CaseIterable {
        case open
        case close
        case high
        case low
        case volume
        case none
        
        var inDim: Int {
            switch self {
            case .volume:
                return 5
            default:
                return 7
            }
        }
        
        var symbol: String {
            switch self {
            case .volume:
                return ""
            default:
                return "$"
            }
        }
        
        public static func forValue(_ string: String) -> ModelType {
            for type in ModelType.allCases {
                if "\(type)" == string {
                    return type
                }
            }
            
            return .none
        }
    }
    
    
    
    public var currentType: ModelType = .open
   
}
