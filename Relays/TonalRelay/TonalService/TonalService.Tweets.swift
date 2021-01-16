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
        
        GraniteLogger.info("fetching -> \(url.absoluteString) - self: \(self)", .relay)
        
        let decoder = JSONDecoder()
        
        return session
                .dataTaskPublisher(for: url)
                .compactMap { (data, response) -> [TonalServiceModels.Tweets]? in
                   
                    let prepare: TonalServiceModels.Tweets.Prepare?
                    do {
                        prepare = try decoder.decode(TonalServiceModels.Tweets.Prepare.self, from: data)
                    } catch let error {
                        prepare = nil
                        GraniteLogger.error("\(error.localizedDescription) - self: \(self)", .relay)
                    }
                    
                    guard let preparedTweet = prepare else { return nil }
                
                    guard let objectData = preparedTweet.result.data(using: .utf8) else { return nil }
                    
                    let meta: [TonalServiceModels.Tweets.Meta]?
                    do {
                        if let json = (try JSONSerialization.jsonObject(with: objectData, options: .mutableContainers)) as? [[String:Any]] {
                            meta = json.map { TonalServiceModels.Tweets.Meta.init(content: $0["content"] as? String ?? "", date: $0["date"] as? Int ?? 0) }
                        } else {
                            meta = nil
                        }
                    } catch let error {
                        meta = nil
                        GraniteLogger.error("\(error.localizedDescription) - self: \(self)", .relay)
                    }
                    
                    guard let metaObject = meta else { return nil }
                    
                    return [TonalServiceModels.Tweets.init(result: metaObject, query: query)]
                
                }.eraseToAnyPublisher()
    }
}
extension TonalServiceModels {
    public struct Tweets: Decodable {
        public struct Meta: Decodable {
            let content: String
            let date: Int
        }
        
        let result: [Meta]
        let query: String
        
        public struct Prepare: Codable {
            let result: String
        }
    }
}
