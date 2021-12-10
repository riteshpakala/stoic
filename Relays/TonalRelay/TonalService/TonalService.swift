//
//  TonalService.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//

import Foundation
import Combine
import SwiftUI

public class TonalService {
    internal let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func stoicV1(matching query: String, since pastDate: String, until toDate: String, count: Int = 100) -> String {
        return "https://ncohrcycu7.execute-api.us-east-2.amazonaws.com/default/stoic-tonal?query=\(query)&until=\(toDate)&since=\(pastDate)&count=\(count)"
    }
    
    var soundAggregate: TonalServiceModels.TonalSounds = .init()
    
    func reset() {
        soundAggregate = .init()
    }
}

public struct TonalServiceModels {
    
}
