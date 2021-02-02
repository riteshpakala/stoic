//
//  NetworkService.Apply.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//

import Foundation
import GraniteUI
import Combine

extension NetworkService {
    public func apply(email: String) -> AnyPublisher<Bool, URLError> {
        guard
            let urlComponents = URLComponents(string: "https://uy887n9tja.execute-api.us-west-1.amazonaws.com/default/stoic-apply")
            else { preconditionFailure("Can't create url components...") }
        
        let json: [String: Any] = ["TableName": "stoic-apply",
                                   "Item": [ "emailId": email,
                                             "created": "\(Date.today.timeIntervalSince1970.asInt)" ]]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        GraniteLogger.info("applying \(email) \n\(url.absoluteString)\nself: \(String(describing: self))", .relay, focus: true)
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        let headers = [
            "x-api-key": "SoSo6lIyCN45RIsZV44YL5fnugt7KniT1dJurV8h"
        ]
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonData
        
        return session
                .dataTaskPublisher(for: request)
                .compactMap { (data, response) -> Bool in
                    return true
                }.eraseToAnyPublisher()
    }
}
