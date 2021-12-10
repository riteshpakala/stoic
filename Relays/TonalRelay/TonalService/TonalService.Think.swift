//
//  TonalService.Think.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/23/21.
//

import Foundation
import Combine
import GraniteUI

extension TonalService {
    public struct TweetOraclePayload {
        let query: String
        let fromDate: String
        let toDate: String
        let next: String?
        let maxResults: Int?
        let sentimentCount: Int
        let lang: String
        let immediate: Bool
        let ticker: String
        var maxId: String? = nil
    }

    class TweetOracle: NSObject {
        public typealias TwitterOracleSuccessHandler = ([TweetMetadata]?) -> Void
        public typealias TwitterOracleFailureHandler = (_ error: Error) -> Void
        public typealias TwitterOracleProgressHandler = (_ fraction: Double) -> Void
        
        let swifter: Swifter
        
        private var emptyPageCount: Int = 0
        private var maxEmptyPages: Int = 4
        private var cycleCount: Int = 0
        private var maxCycleCount: Int = 4
        private var isAuthorized: Bool = false
        private var shouldCancel: Bool = false
        
        private var collected: [TweetMetadata] = []
        
        struct TweetMetadata {
            let name: String
            let followersCount: Int
            let retweetCount: Int
            let favouritesCount: Int
            let urls: [String]
            let symbols: [String]
            let text: String
            let createdAt: String
            
            
            var asDate: Date {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
                return formatter.date(from: createdAt) ?? Date()
            }
            
            var toString: String {
                """
                name: \(name)
                followers: \(followersCount)
                retweets: \(retweetCount)
                favourites: \(favouritesCount)
                urls: \(urls.count)
                symbols: \(symbols)
                text: \(text)
                createdAt: \(createdAt)
                date: \(asDate.asString)
                """
            }
        }
        
        public override init() {
            swifter = .init(consumerKey: "YfotrHzdTUfA1swS0MQj3cqdg", consumerSecret: "BrCZ67oKoROeZJUPJ46bEqj8kNrJVE2MtHJDwrprMclpRqtDTE", appOnly: true)
            super.init()
        }
        
        func begin(using oracle: TweetOraclePayload,
                   success: TwitterOracleSuccessHandler? = nil,
                   progress: TwitterOracleProgressHandler? = nil,
                   failure: TwitterOracleFailureHandler? = nil) {
            
//            let oracle: TweetOraclePayload = .init(
//                query: payload.ticker,
//                fromDate: since,
//                toDate: until,
//                next: nil,
//                maxResults: nil,
//                sentimentCount: count,
//                lang: langCode,
//                immediate: immediate,
//                ticker: payload.symbolName)
            
            reset()
            shouldCancel = false
            
            guard !isAuthorized else {
                self.search(oracle, success: success, progress: progress, failure: failure)
                return
            }
            
            swifter.authorizeAppOnly(success: { [weak self] (token, response) in
                self?.search(oracle, success: success, progress: progress, failure: failure)
                self?.isAuthorized = true
            }, failure: { (error) in
                GraniteLogger.info("Think error: \(error.localizedDescription)", .utility, focus: true)
            })
            
        }
        
        func search(
            _ oracle: TweetOraclePayload,
            queryToRefreshWith: String? = nil,
            success: TwitterOracleSuccessHandler? = nil,
            progress: TwitterOracleProgressHandler? = nil,
            failure: TwitterOracleFailureHandler? = nil) {
            let query = oracle.query
            
            //////// PRODUCTION
            self.swifter.searchTweet(
                using: query,
                lang: oracle.lang,
                count: 100,
                until: oracle.toDate,
                sinceID: oracle.maxId,
                includeEntities: true,
                success: { (test, test2) in
                    DispatchQueue.global(qos: .utility).async {
                        if let array = test.array {

                            for item in array {
                                guard !self.shouldCancel else { break }
                                
                                let object = item.object

                                let user = object?["user"]
                                let name = user?.object?["screen_name"]?.string ?? ""
                                let followers = user?.object?["followers_count"]?.double ?? 0.0

                                let retweets = object?["retweet_count"]?.double ?? 0.0
                                let favorites = object?["favorite_count"]?.double ?? 0.0

                                let entities = object?["entities"]?.object
                                let urls: [String] = (entities?["urls"]?.array?.map({ $0.object?["expanded_url"]?.string ?? "" })) ?? []
                                let symbols: [String] = (entities?["symbols"]?.array?.map({ $0.object?["text"]?.string ?? "" })) ?? []
                                let text: String = object?["text"]?.string ?? ""
                                let createdAt = object?["created_at"]?.string ?? ""

                                let metadata: TweetMetadata = .init(
                                    name: name,
                                    followersCount: Int(followers),
                                    retweetCount: Int(retweets),
                                    favouritesCount: Int(favorites),
                                    urls: urls,
                                    symbols: symbols,
                                    text: text,
                                    createdAt: createdAt)
                                
                                //Flags

                                let theCashtag: Bool = !metadata.symbols.isEmpty && metadata.symbols.count <= 6 && (metadata.symbols.map({ $0.lowercased() }).contains(oracle.query.lowercased()) || text.lowercased().components(separatedBy: oracle.ticker.lowercased()).count > 1)

                                let theCompany: Bool = self.cycleCount > 0 && text.lowercased().components(separatedBy: query).count > 1
                                //
    //                            let theDate: Bool
    //                            let targetDate = (oracle.fromDate.asDate() ?? Date()).dateComponents()
    //                            let tweetDate = metadata.asDate.dateComponents()
    //                            if tweetDate.day <= targetDate.day &&
    //                                tweetDate.month <= targetDate.month &&
    //                                tweetDate.year <= targetDate.year {
    //                                theDate = true
    //                            } else {
    //                                theDate = false
    //                            }
                                //

                                //TODO: Used to be no links, but we should scrape the link soon
                                // ...
                                //
                                let theURLs: Bool = metadata.urls.isEmpty || (text.count > 24)

                                let collectedContent: [String] = self.collected.map({ $0.text.lowercased() })
                                let theDupe: Bool = !collectedContent.contains(text.lowercased())

                                if (theCashtag || theCompany), theURLs, theDupe {
                                    self.collected.append(metadata)
                                } else {
//                                    GraniteLogger.info("Think error: \(metadata.text) \(theCashtag) \(theCompany) \(theURLs) \(theDupe)", .utility, focus: true)
                                }
                            }

                            guard !self.shouldCancel else { return }

                            if (self.emptyPageCount < self.maxEmptyPages || self.cycleCount < self.maxCycleCount) && self.collected.isEmpty {

                                var oracleToRefresh: TweetOraclePayload = oracle
                                if let id = test2.object?["next_results"]?.string,
                                   self.emptyPageCount < self.maxEmptyPages {
                                    let maxId = id.components(separatedBy: "&q").first?.components(separatedBy: "?max_id=").last ?? id
                                    
                                    oracleToRefresh.maxId = maxId
                                }


                                if self.emptyPageCount < self.maxEmptyPages {
                                    self.emptyPageCount+=1
                                } else {
                                    oracleToRefresh.maxId = nil
                                    self.cycleCount+=1
                                    self.emptyPageCount = 0
                                }
                                
                                self.search(
                                    oracleToRefresh,
                                    queryToRefreshWith: self.emptyPageCount == 0 ? nil : query,
                                    success: success,
                                    progress: progress,
                                    failure: failure)
                                
                            } else {
                                success?(self.collected)
                                self.reset()
                            }
                        }
                    }
             },
                failure: { error in
                    failure?(error)
                    GraniteLogger.info("Think error: \(error.localizedDescription)", .utility, focus: true)
            })
        }
        
        func cancel() {
            shouldCancel = true
        }
        
        func reset() {
            collected.removeAll()
            self.emptyPageCount = 0
            self.cycleCount = 0
        }
        
        func clean() {
            cancel()
            reset()
        }
    }

    /****

     Premium // 30Day logic

     //            self.swifter.searchTweet2(
     //                using: self.searchQuery,
     //                fromDate: "202008180209",
     //                toDate: "202008190209",
     //                maxResults: "100",
     //                success: { (test, _) in
     //
     //
     //                    if let dict = test.dictionary {
     //                        if let items = dict["results"] {
     //                        }
     //                    }
     //            },
     //                failure: { error in
     //            })
     
     
     */

}
