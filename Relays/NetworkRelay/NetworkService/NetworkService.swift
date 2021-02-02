//
//  StockService.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//

import Foundation
import Combine

public class NetworkService {
    internal let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    
}

public struct NetworkServiceModels {
    
}
