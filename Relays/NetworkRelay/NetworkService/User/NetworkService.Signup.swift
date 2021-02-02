//
//  NetworkService.Signup.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//

import Foundation
import GraniteUI
import Combine

extension NetworkService {
    public func signup(uid: String, email: String, username: String) -> AnyPublisher<Bool, URLError> {
        guard
            let urlComponents = URLComponents(string: "https://fchrx7pnd7.execute-api.us-west-1.amazonaws.com/default/stoic-user")
            else { preconditionFailure("Can't create url components...") }
        
        let json: [String: Any] = ["TableName": "stoic-user",
                                   "Item": [ "userid": uid,
                                             "email": email,
                                             "username": username,
                                             "created": "\(Date.today.timeIntervalSince1970.asInt)",
                                             "lastOnline": "\(Date.today.timeIntervalSince1970.asInt)",
                                             "rank": "0",]]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        GraniteLogger.info("signing up \(email) \n\(url.absoluteString)\nself: \(String(describing: self))", .relay, focus: true)
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        let headers = [
            "x-api-key": "Czyz1I5m1F7JNucOeJltO6B2Jd9tUSbL6cKpVRWY"
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
