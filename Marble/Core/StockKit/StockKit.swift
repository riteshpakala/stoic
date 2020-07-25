//
//  StockKit.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

class SwiftStockKit {
    var searchTask: URLSessionTask? = nil
    func fetchStocksFromSearchTerm(term: String) {
        searchTask?.cancel()
        
        let searchURLasString = "https://symlookup.cnbc.com/symservice/symlookup.do?prefix=\(term)&partnerid=20064&pgok=1&pgsize=50"
        
        if let url = URL(string: searchURLasString) {
            searchTask = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                    }
                }
                
                if error != nil {
                    print(error?.localizedDescription)
                    print(response)
                }
            }
            
            searchTask?.resume()
        }
    }
    
    var csvTask: URLSessionTask? = nil
    func getCSV(forTicker ticker: String) {
        csvTask?.cancel()
        
        let csvURLasString = "https://query1.finance.yahoo.com/v7/finance/download/\(ticker)?period1=1092873600&period2=1591488000&interval=1d&events=history"
        
        
        if let url = URL(string: csvURLasString) {
            csvTask = URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                 }
               }
            }
            csvTask?.resume()
        }
    }
}
