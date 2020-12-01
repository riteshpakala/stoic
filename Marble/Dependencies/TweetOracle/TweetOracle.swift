//
//  TweetOracle.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/17/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

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
    public typealias TwitterOracleSuccessHandler = ([(Tweet, VaderSentimentOutput)]) -> Void
    public typealias TwitterOracleFailureHandler = (_ error: Error) -> Void
    public typealias TwitterOracleProgressHandler = (_ fraction: Double) -> Void
    
    let swifter: Swifter
    private var searchPayload: StockSearchPayload?

    private var results: [(Tweet, VaderSentimentOutput)] = []
    private var emptyPageCount: Int = 0
    private var maxEmptyPages: Int = 4
    private var cycleCount: Int = 0
    private var maxCycleCount: Int = 4
    var searchQuery: String {
        searchPayload?.cycle(cycleCount) ?? ""
    }
    private var isAuthorized: Bool = false
    private var shouldCancel: Bool = false
    
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
        
        var asTweet: Tweet {
            return .init(text: text, time: "\(Int(asDate.timeIntervalSince1970))", lang: "en")
        }
    }
    
    public override init() {
        swifter = .init(consumerKey: "YfotrHzdTUfA1swS0MQj3cqdg", consumerSecret: "BrCZ67oKoROeZJUPJ46bEqj8kNrJVE2MtHJDwrprMclpRqtDTE", appOnly: true)
        super.init()
    }
    
    func begin(using payload: StockSearchPayload,
               since: String,
               until: String,
               count: Int,
               langCode: String,
               immediate: Bool = false,
               success: TwitterOracleSuccessHandler? = nil,
               progress: TwitterOracleProgressHandler? = nil,
               failure: TwitterOracleFailureHandler? = nil) {
        
        self.searchPayload = payload
        let oracle: TweetOraclePayload = .init(
            query: payload.ticker,
            fromDate: since,
            toDate: until,
            next: nil,
            maxResults: nil,
            sentimentCount: count,
            lang: langCode,
            immediate: immediate,
            ticker: payload.symbolName)
        
        reset()
        shouldCancel = false
        
        guard !isAuthorized else {
            self.search(oracle, success: success, progress: progress, failure: failure)
            return
        }
        
        swifter.authorizeAppOnly(success: { [weak self] (token, response) in
            self?.search(oracle, success: success, progress: progress, failure: failure)
            self?.isAuthorized = true
        }, failure: { (faulre) in
        
            print("{TEST} \(faulre.localizedDescription)")
        })
        
    }
    
    func search(
        _ oracle: TweetOraclePayload,
        queryToRefreshWith: String? = nil,
        success: TwitterOracleSuccessHandler? = nil,
        progress: TwitterOracleProgressHandler? = nil,
        failure: TwitterOracleFailureHandler? = nil) {
        let query = queryToRefreshWith ?? self.searchQuery
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
                            
                            
                            let theURLs: Bool = metadata.urls.isEmpty || (self.cycleCount > 0 && metadata.urls.count <= 1)
                            
                            let collected: [String] = self.results.map({ $0.0.text.lowercased() })
                            let theDupe: Bool = !collected.contains(text.lowercased())
                            
                            if (theCashtag || theCompany), theURLs, theDupe {

                                let prediction = VaderSentiment.predict(metadata.text)
                                let theSentiment: Bool = prediction.compound != 0
                                print("%%%%%%%%%\n Sentiment Candidate \n%%%%%%\n\n")
                                print(metadata.toString)
                                print("%%%%%%%%%\n query: \(query) :: \(prediction.asString) \n%%%%%%\n\n")
                                if theSentiment {
                                    
                                    self.results.append((metadata.asTweet, prediction))
                                    
                                    if oracle.immediate {
                                        break
                                    }
                                }
                            } else {
//                                print(metadata.toString)
//                                print("###########\n errror :: query: \(query) \n###########\n\n")
                            }
                        }
                        
                        guard !self.shouldCancel else { return }
                        
                        if (((self.results.count < oracle.sentimentCount) || self.results.isEmpty) &&
                            (self.emptyPageCount < self.maxEmptyPages || self.cycleCount < self.maxCycleCount )) {

                            var oracleToRefresh: TweetOraclePayload = oracle
                            if let id = test2.object?["next_results"]?.string, self.emptyPageCount < self.maxEmptyPages {
                                let maxId = id.components(separatedBy: "&q").first?.components(separatedBy: "?max_id=").last ?? id
                                
//                                print("{TEST} parsing max \(maxId)")
                                oracleToRefresh.maxId = maxId
                            }
                            
                            
                            if self.emptyPageCount < self.maxEmptyPages {
                                self.emptyPageCount+=1
                            } else {
                                oracleToRefresh.maxId = nil
                                self.cycleCount+=1
                                self.emptyPageCount = 0
                            }
                            
                            print("{SENTIMENT} refresh \(self.emptyPageCount)")
                            self.search(
                                oracleToRefresh,
                                queryToRefreshWith: self.emptyPageCount == 0 ? nil : query,
                                success: success,
                                progress: progress,
                                failure: failure)
//                            print("{TEST} \(self.results.count) refresh \(oracleToRefresh.maxId)")
                        } else {
                            print("{SENTIMENT} final \(self.results.count)")
                            success?(Array(self.results.prefix(oracle.sentimentCount)))
                            self.reset()
                        }
                    }
                }
         },
            failure: { error in
                failure?(error)
                print("{TEST} \(error.localizedDescription)")
        })
    }
    
    func cancel() {
        shouldCancel = true
    }
    
    func reset() {
        results.removeAll()
        self.emptyPageCount = 0
        self.cycleCount = 0
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
 //                            print("{TEST} \(items.dictionary?.count)")
 //                        }
 //                    }
 //            },
 //                failure: { error in
 //                    print("{TEST} \(error.localizedDescription)")
 //            })
 
 
 */
