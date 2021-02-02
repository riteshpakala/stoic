//
//  TonalServiceTweets.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//

import Foundation
import Combine
import GraniteUI

extension TonalService {
    public func getTweets(matching query: String, since pastDate: Date, until toDate: Date, count: Int = 100) -> AnyPublisher<[TonalServiceModels.Tweets], URLError> {
        guard
            let urlComponents = URLComponents(string: stoicV1(matching: query, since: pastDate.asString, until: toDate.asString, count: count))
            else { preconditionFailure("Can't create url components...") }

        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        GraniteLogger.info("fetching -> \(url.absoluteString) - self: \(String(describing: self))", .relay)
        
        let decoder = JSONDecoder()
        
        return session
                .dataTaskPublisher(for: url)
                .compactMap { (data, response) -> [TonalServiceModels.Tweets]? in
                   
                    let prepare: [TonalServiceModels.Tweets.Meta]?
                    do {
                        prepare = try decoder.decode([TonalServiceModels.Tweets.Meta].self, from: data)
                    } catch let error {
                        prepare = nil
                        GraniteLogger.info("\(error) - self: \(String(describing: self))", .relay, focus: true)
                    }
                    
                    guard let preparedTweet = prepare else { return nil }
                    
                    return [TonalServiceModels.Tweets.init(result: preparedTweet, query: query)]
                
                }.eraseToAnyPublisher()
    }
}
extension TonalServiceModels {
    public struct Tweets: Codable {
        public struct Response: Codable {
            let result: [Meta]
            
            enum CodingKeys: String, CodingKey {
                case result = "result"
            }
        }
        
        public struct Meta: Codable {
            let content: String
            let date: Int
            
            enum CodingKeys: String, CodingKey {
                case content = "content"
                case date = "date"
            }
        }
        
        let result: [Meta]
        let query: String
        
        public struct Prepare: Codable {
            let result: String
        }
    }
}
