//
//  TwitterScraper.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/22/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public class TwitterScraper: NSObject {
    public typealias SuccessHandler = (JSONSwifter) -> Void
    public typealias CursorSuccessHandler = (JSONSwifter, _ previousCursor: String?, _ nextCursor: String?) -> Void
    public typealias TwitterScraperSuccessHandler = ([Tweet], _ response: HTTPURLResponse?) -> Void
    public typealias TwitterScraperProgressHandler = (String, _ fraction: Double) -> Void
    public typealias SearchResultHandler = (JSONSwifter, _ searchMetadata: JSONSwifter) -> Void
    public typealias FailureHandler = (_ error: Error) -> Void
    
    let dataEncoding: String.Encoding = .utf8
    
    var results: [Tweet] = []
    var defaultHourlyTweets: Int = 4
    var cursorHour: Int = 20
    var cursorHourMove: Int = 4
    var defaultHour: Int = 20
    var cursorTweets: Int = 1
    var cursorMinute: Int {
        guard cursorTweets + 1 > 0 else { return 60 }
        return 60 - (60/(cursorTweets + 1))
    }
    var activeRequest: HTTPRequest?
    var isCancelled: Bool = false
    private var emptyPageCount: Int = 0
    private var maxEmptyPages: Int = 4
    private var searchPayload: StockSearchPayload?
    var searchQuery: String {
        searchPayload?.cycle(emptyPageCount) ?? ""
    }
    
    private var _max_id: String {
        guard let dateString = _sinceDate,
              let date = Calendar.nyDateFormatter.date(
                from: dateString) else { return "" }
        
        var components = Calendar.nyCalendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date)
        
        components.hour = cursorHour
        
        guard let newDate = Calendar.nyCalendar.date(from: components) else {
            return ""
        }
        let msEpoch = newDate.millisecondsSince1970
        let id = (msEpoch - 1288834974657) << 22
        
        return " max_id:\(id)"
    }
    private var _sinceDate: String? = nil
    
    public func begin(using payload: StockSearchPayload,
        username: String? = nil,
        near: String? = nil,
        since: String,
        until: String? = nil,
        count: Int = 0,
        refresh: String = "",
        filterLangCode: String? = nil,
        isUniqueTicker: (enabled: Bool, mentions: Int) = (true, 2),
        noLinks: Bool = false,
        cleanLinks: Bool = true,
        isSpread: Bool = true,
        success: TwitterScraperSuccessHandler? = nil,
        progress: TwitterScraperProgressHandler? = nil,
        failure: HTTPRequest.FailureHandler? = nil) {
        
        cancel()
        reset()
        
        self.searchPayload = payload
        self._sinceDate = since
        
        searchTweet(
            using: searchQuery,
            username: username,
            near: near,
            since: since,
            until: until,
            count: count,
            refresh: refresh,
            filterLangCode: filterLangCode,
            isUniqueTicker: isUniqueTicker,
            noLinks: noLinks,
            cleanLinks: cleanLinks,
            isSpread: isSpread,
            success: success,
            progress: progress,
            failure: failure)
    }
    
    public func searchTweet(
        using query: String,
        username: String? = nil,
        near: String? = nil,
        since: String,
        until: String? = nil,
        count: Int = 0,
        refresh: String = "",
        filterLangCode: String? = nil,
        isUniqueTicker: (enabled: Bool, mentions: Int) = (true, 2),
        noLinks: Bool = false,
        cleanLinks: Bool = false,
        isSpread: Bool = false,
        success: TwitterScraperSuccessHandler? = nil,
        progress: TwitterScraperProgressHandler? = nil,
        failure: HTTPRequest.FailureHandler? = nil) {
        
        guard (count > 0 && results.count < count) || count == 0 || cursorHour <= 0 else {
            
            success?(results, nil)
            
            return
        }
        
        let JSONSwifterDownloadProgressHandler: HTTPRequest.DownloadProgressHandler = { [weak self] data, received, expected, response in
            
            

        }
        
        cursorTweets = cursorTweets <= 0 ? defaultHourlyTweets : cursorTweets
        
        let JSONSwifterSuccessHandler: HTTPRequest.SuccessHandler = { [weak self] data, response in
            
            DispatchQueue.global(qos: .utility).async {
                do {
                    guard let this = self, !this.isCancelled else { return }
                    let jsonData = try JSON(data: data)
                    let refreshCursor: String = jsonData.dictionaryValue["min_position"]?.string ?? refresh
                    
                    guard let items = jsonData.dictionaryValue["items_html"] else { return }
                    
                    let doc: Document = try SwiftSoup.parse(items.string ?? "")
                    
                    let elesText = try doc.select("div.js-tweet-text-container")
                    let elesTime = try doc.select("span.js-short-timestamp")
                    let elesLang = try? doc.select("p.js-tweet-text")
                    
                    
                    let minimumTimeComponentHour: Int
                    if isSpread {
                        let times: [Double] = elesTime.array().map { try? $0.attr("data-time") }.map { Double($0 ?? "") ?? Double.greatestFiniteMagnitude }
                        minimumTimeComponentHour = (times.min() ?? 0.0).date().timeComponents().hour
                    } else {
                        minimumTimeComponentHour = -100000
                    }
                    
                    if minimumTimeComponentHour <= this.cursorHour {
                        if elesText.count > 0 {
                            for (index, ele) in elesText.enumerated() {
                                guard this.results.count < count,
                                    (this.cursorTweets > 0) || !isSpread,
                                    this.cursorHour > 0 || !isSpread,
                                    !this.isCancelled else {
                                        
                                    break
                                }
                                let time: String = elesTime.array().count > index ? (try? elesTime.array()[index].attr("data-time")) ?? "" : ""
                                
                                
                                let targetDate = (since.asDate() ?? Date()).dateComponents()
                                let tweetDate = (Double(time)?.date() ?? Date()).dateComponents()
                                guard tweetDate.day <= targetDate.day &&
                                    tweetDate.month <= targetDate.month &&
                                    tweetDate.year <= targetDate.year else {
                                    
                                    break
                                }
                                
                                
                                let text: String = (try? ele.text()) ?? ""
                                let lang: String = (elesLang?.array().count ?? -1) > index ? (try? elesLang?.array()[index].attr("lang")) ?? "" : ""
                                
                                
                                
    //                            if let doubleTime = Double(time) {
    //                                let date = Date(timeIntervalSince1970: doubleTime)
    //                                let dateFormatter = DateFormatter()
    //                                dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
    //                                dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
    //                                dateFormatter.timeZone = Calendar.nyTimezone
    //                                let localDate = dateFormatter.string(from: date)
    //
    //                                print("{TEST} time \(localDate)")
    //                            }
                                
                                let timeComponents = Double(time)?.date().timeComponents()
                                let hour: Int = timeComponents?.hour ?? 0
                                let minute: Int = timeComponents?.minute ?? 0
                                let tickerQueryCount: Int = (text.filter( { $0 == "$" } ).count)
                                if (filterLangCode == nil || filterLangCode == lang),
                                    VaderSentiment.predict(text).compound != 0,
                                    (hour <= this.cursorHour) || !isSpread,
                                    (minute < this.cursorMinute) || !isSpread,
                                    (!this.linkExists(in: text) || !noLinks),
                                    ((tickerQueryCount <= isUniqueTicker.mentions && text.count > query.count && tickerQueryCount >= 1) || (!isUniqueTicker.enabled)) {
                                    
                                    
                                    //
                                    this.results.append(
                                        Tweet.init(
                                            text: cleanLinks ? this.removeLinks(in: text) : text,
                                            time: time,
                                            lang: lang)
                                    )
                                    //
                                    
//                                    print("{TEST} tweetHour: \(hour) hour: \(this.cursorHour), minute: \(this.cursorMinute), tweet: \(this.cursorTweets)")
                                    
                                    //this.cursorHour = hour
                                    this.cursorTweets -= 1
                                    
                                    if this.cursorTweets <= 0 && isSpread {
                                        this.cursorHour -= this.cursorHourMove
                                    }
                                    
                                    progress?(text, Double(this.results.count))
                                }
                            }
                        } else {
                            this.emptyPageCount += 1
                        }
                    }
                    
                    let didNotReachMaxEmpty: Bool = this.emptyPageCount - 1 < this.maxEmptyPages
                    
                    if  !this.isCancelled,
                        didNotReachMaxEmpty {
                        this.searchTweet(
                            using: this.searchQuery,
                            since: since,
                            until: until,
                            count: count,
                            refresh: refreshCursor,
                            filterLangCode: filterLangCode,
                            isUniqueTicker: isUniqueTicker,
                            noLinks: noLinks,
                            isSpread: isSpread,
                            success: success,
                            progress: progress,
                            failure: failure)
                    } else if !didNotReachMaxEmpty {
                        success?(this.results, response)
                    }
                } catch {
                    DispatchQueue.main.async {
                        if case 200...299 = response.statusCode, data.isEmpty {
                            success?(self?.results ?? [], response)
                        } else {
                            failure?(error)
                        }
                    }
                }
            }
        }
        
        let path: String = "https://twitter.com/i/search/timeline?f=tweets&q=%@&src=typd&max_position=%@"
       
        let pathData: String = " "+query+"\(isSpread ? self._max_id : "")"+" since:"+since+" until:"+(until ?? since)
        
        let finalPath = String(
            format: path,
            pathData.addingPercentEncoding(
                withAllowedCharacters: .urlPathAllowed) ?? "",
            refresh.addingPercentEncoding(
                withAllowedCharacters: .urlPathAllowed) ?? "")
        
        activeRequest = self.get(
            finalPath,
            downloadProgress: JSONSwifterDownloadProgressHandler,
            success: JSONSwifterSuccessHandler,
            failure: failure)
    }
    
    func linkExists(in input: String) -> Bool {
        guard let detector = try? NSDataDetector(
            types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        let matches = detector.matches(
            in: input,
            options: [],
            range: NSRange(location: 0, length: input.utf16.count))

        return matches.count > 0
    }
    
    func removeLinks(in input: String) -> String{
        var text = input
        guard let detector = try? NSDataDetector(
            types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return text
        }
        let matches = detector.matches(
            in: input,
            options: [],
            range: NSRange(location: 0, length: input.utf16.count))
        
        for match in matches {
            if let range = Range(match.range, in: text) {
                text.removeSubrange(range)
            }
        }
        
        return text
    }
    
    func cancel() {
        activeRequest?.stop()
        activeRequest = nil
        isCancelled = true
    }
    
    func reset() {
        results.removeAll()
        results = []
        
        cursorHour = defaultHour
        cursorTweets = defaultHourlyTweets
        
        isCancelled = false
        
        emptyPageCount = 0
        
        searchPayload = nil
        _sinceDate = nil
    }
    
    func get(_ path: String,
             downloadProgress: HTTPRequest.DownloadProgressHandler?,
             success: HTTPRequest.SuccessHandler?,
             failure: HTTPRequest.FailureHandler?) -> HTTPRequest {
        let url = URL(string: path)
        
        let request = HTTPRequest(url: url!, method: .GET, parameters: [:])
        request.downloadProgressHandler = downloadProgress
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = self.dataEncoding
        
        request.headers = ["Host": "twitter.com",
            "User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36",
            "Accept":"application/json, text/javascript, */*; q=0.01",
            "Accept-Language":"de,en-US;q=0.7,en;q=0.3",
            "X-Requested-With":"XMLHttpRequest",
            "Referer": url!.relativeString,
            "Connection":"keep-alive"];
        
        request.start()
        return request
    }
}
