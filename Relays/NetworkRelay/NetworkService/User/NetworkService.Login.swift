//
//  NetworkService.Login.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//

import Foundation
import GraniteUI
import Combine

extension NetworkService {
    public func login(uid: String) -> AnyPublisher<NetworkServiceModels.User.Item?, URLError> {
        guard
            var urlComponents = URLComponents(string: "https://fchrx7pnd7.execute-api.us-west-1.amazonaws.com/default/stoic-user")
            else { preconditionFailure("Can't create url components...") }
        
        let tableQuery: URLQueryItem = .init(name: "TableName", value: "stoic-user")
        let idQuery: URLQueryItem = .init(name: "uid", value: uid)
        
        urlComponents.queryItems = [tableQuery, idQuery]
        
        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        GraniteLogger.info("logging in \(uid) \n\(url.absoluteString)\nself: \(String(describing: self))", .relay, focus: true)
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        let headers = [
            "x-api-key": "Czyz1I5m1F7JNucOeJltO6B2Jd9tUSbL6cKpVRWY"
        ]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let decoder = JSONDecoder()
        return session
                .dataTaskPublisher(for: request)
                .compactMap { (data, response) -> NetworkServiceModels.User.Item? in
                    let users: NetworkServiceModels.User?
                    do {
                        
                        users = try decoder.decode(NetworkServiceModels.User.self, from: data)
                    } catch let error {
                        users = nil
                        GraniteLogger.error("failed fetching user:\n\(error.localizedDescription)\nself: \(String(describing: self))", .relay)
                    }
                    return users?.Items.first
                }.eraseToAnyPublisher()
    }
}

extension NetworkServiceModels {
    public struct User: Codable {
        public struct Item: Codable {
            var created: String
            var email: String
            var username: String
        }
        
        var Items: [Item]
    }
}
