//
//  StockService.Utilities.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//

import Foundation

public struct StockServiceUtilities {
    public static func parseCSV (
                        ticker: String,
                        content: String)
                        -> [StockData]? {

       // Load the CSV file and parse it
        let delimiter = ","
        var items:[StockData]? = []

        let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]

        for line in lines {
            
            var values:[String] = []
            if line != "" {
                // For a line with double quotes
                // we use NSScanner to perform the parsing
                if line.range(of: "\"") != nil {
                    var textToScan:String = line
                    var value:NSString?
                    var textScanner:Scanner = Scanner(string: textToScan)
                    while textScanner.string != "" {

                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
                            textScanner.scanLocation += 1
                            textScanner.scanUpTo("\"", into: &value)
                            textScanner.scanLocation += 1
                        } else {
                            textScanner.scanUpTo(delimiter, into: &value)
                        }

                        // Store the value into the values array
                        if let value = value as String? {
                            values.append(value)
                        }


                        // Retrieve the unscanned remainder of the string
                        if textScanner.scanLocation < textScanner.string.count {
                            textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                        } else {
                            textToScan = ""
                        }
                        textScanner = Scanner(string: textToScan)
                    }

                    // For a line without double quotes, we can simply separate the string
                    // by using the delimiter (e.g. comma)
                } else  {
                    values = line.components(separatedBy: delimiter)
                }

                if  values.count > 0,//Double(values[0]),
                    let open = Double(values[1]),
                    let high = Double(values[2]),
                    let low = Double(values[3]),
                    let close = Double(values[4]),
                    let volume = Double(values[6]) {

                    let item: StockData = StockData.init(
                        symbolName: ticker,
                        dateData: .init(values[0]),
                        open:open,
                        high:high,
                        low:low,
                        close:close,
                        volume: volume)
                    // Put the values into the tuple and add it to the items array

                    items?.insert(item, at: 0)
                }
            }
        }

        return items/*?.sorted(
                    by: {
                        ($0.dateData.asDate ?? Date()).compare(($1.dateData.asDate ?? Date())) == .orderedDescending })*/
    }
}
