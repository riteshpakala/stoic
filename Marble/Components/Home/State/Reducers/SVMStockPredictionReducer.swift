//
//  ReducerTest.swift
//  Marble
//
//  Created by Ritesh Pakala on 5/14/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct SVMStockPredictionReducer: Reducer {
    typealias ReducerEvent = HomeEvents.SVMStockTestEvent
    typealias ReducerState = HomeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let url = Bundle.main.url(forResource: "goog", withExtension: "csv") else {
            return
        }
        
        guard let stockData = parseCSV(
            contentsOfURL: url as NSURL,
            fromDate: 2020,
            fromMonth: 5,
            fromDay: 1,
            encoding: .utf8,
            error: .none), !stockData.isEmpty else {
            return
        }
        print(stockData)
        print("\n###############\n")
        let data = DataSet(dataType: .Regression, inputDimension: 1, outputDimension: 1)
        for day in stockData {
            do {
                try data.addDataPoint(input: [day.date], output: [day.close])
            }
            catch {
                print("Invalid data set created")
            }
        }
        
        let svm = SVMModel(
            problemType: .ϵSVMRegression,
            kernelSettings:
            KernelParameters(type: .RadialBasisFunction,
                             degree: 0,
                             gamma: 0.1,
                             coef0: 0.0))
        svm.Cost = 1e3
        svm.train(data: data)
        
//        1,309,408
//        Avg. Volume    2,465,803

        
        let testData = DataSet(dataType: .Regression, inputDimension: 1, outputDimension: 1)
        do {
            try testData.addTestDataPoint(input: [29])
//            try testData.addTestDataPoint(input: [20200522.0])
        }
        catch {
            print("Invalid data set created")
        }
        svm.predictValues(data: testData)
        var outputs : [[Double]]?
        do {
            try outputs = testData.outputs
        }
        catch {
            outputs = nil
            print("Error in prediction")
        }
        
        print("\n###############\n")
        
        print("Prediction: \(outputs)")
        
        state.test += 1
        
        
    }
    
    func parseCSV (
        contentsOfURL: NSURL,
        fromDate: Double,
        fromMonth: Double,
        fromDay: Double,
        encoding: String.Encoding,
        error: NSErrorPointer)
        -> [(date:Double,
        open:Double,
        high: Double,
        low: Double,
        close: Double,
        adjClose: Double,
        volume: Double)]? {
            
       // Load the CSV file and parse it
        let delimiter = ","
        var items:[(date:Double, open:Double, high: Double, low: Double, close: Double, adjClose: Double, volume: Double)]?

        //if let content = String(contentsOfURL: contentsOfURL, encoding: encoding, error: error) {
        if let content = try? String(contentsOf: contentsOfURL as URL, encoding: encoding) {
            items = []
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
                        if let first = values.first {
                            let components = first.components(separatedBy: "-")
                            
                            var passed: Bool = false
                            if let year = Double(components.first ?? ""),
                                year >= fromDate {
                                passed = true
                            } else {
                                continue
                            }
                            
                            if  1 < components.count,
                                let month = Double(components[1]),
                                month >= fromMonth {
                                passed = true
                            } else {
                                continue
                            }
                            
                            if  2 < components.count,
                                let day = Double(components[2]),
                                day >= fromDay {
                                passed = true
                            } else {
                                continue
                            }
                            
                            if passed {
                                values[0] = components[2] //"12"+components.reversed().joined()
                            }
                        }
                    }
                    
                    if  let date = Double(values[0]),
                        let open = Double(values[1]),
                        let high = Double(values[2]),
                        let low = Double(values[3]),
                        let close = Double(values[4]),
                        let adjClose = Double(values[5]),
                        let volume = Double(values[6]) {
                        let item = (date:date, open:open, high:high, low:low, close:close, adjClose:adjClose, volume: volume)

                        // Put the values into the tuple and add it to the items array
                        
                        items?.append(item)
                    }
                    
                    
                }
            }
        }

        return items
    }
}
