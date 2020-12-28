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
    internal let decoder: JSONDecoder
    
    public init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    public func stoicV1(matching query: String, since pastDate: String, until toDate: String, count: Int = 100) -> String {
        return "https://ritesh-d2a6fee2-eval-prod.apigee.net/understand/tonal/social?query=\(query)&until=\(toDate)&since=\(pastDate)&count=\(count)"
    }
    
    var soundAggregate: TonalServiceModels.TonalSounds = .init()
    
    func reset() {
        soundAggregate = .init()
    }
}

public struct TonalServiceModels {
    
}
