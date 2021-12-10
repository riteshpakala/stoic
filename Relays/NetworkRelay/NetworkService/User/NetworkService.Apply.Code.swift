//
//  NetworkService.Apply.Code.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/5/21.
//

import Foundation
import GraniteUI
import Combine

extension NetworkService {
    public func isValidCode(_ code: String) -> AnyPublisher<[NetworkServiceModels.Apply.Code.Meta], URLError> {
        guard
            var urlComponents = URLComponents(string: "https://088g1aslna.execute-api.us-west-1.amazonaws.com/default/stoic-apply-code")
            else { preconditionFailure("Can't create url components...") }
        
        let tableQuery: URLQueryItem = .init(name: "TableName", value: "stoic-apply-code")
        let codeQuery: URLQueryItem = .init(name: "code", value: code)

        urlComponents.queryItems = [tableQuery, codeQuery]
        
        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        let headers = [
            "x-api-key": "TEXPY1SbVd72UsYepq7evovGAFJcuhm3Yyawnth9"
        ]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let decoder = JSONDecoder()
        
        return session
                .dataTaskPublisher(for: request)
                .compactMap { (data, response) -> [NetworkServiceModels.Apply.Code.Meta] in
                    let applyCode: NetworkServiceModels.Apply.Code?
                    do {
                        
                        applyCode = try decoder.decode(NetworkServiceModels.Apply.Code.self, from: data)
                    } catch let error {
                        applyCode = nil
                        GraniteLogger.info("failed fetching code:\n\(error.localizedDescription)\nself: \(String(describing: self))", .relay, focus: true)
                    }
                
                    return applyCode?.Items ?? []
                }.eraseToAnyPublisher()
    }
}

extension NetworkServiceModels {
    public struct Apply: Codable {
        public struct Code: Codable {
            public struct Meta: Codable {
                let code: String
                let isValid: Bool
            }
            let Items: [Meta]
        }
    }
}
