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
    public typealias TwitterScraperProgressHandler = ([Tweet], _ fraction: Double) -> Void
    public typealias SearchResultHandler = (JSONSwifter, _ searchMetadata: JSONSwifter) -> Void
    public typealias FailureHandler = (_ error: Error) -> Void
    
    let dataEncoding: String.Encoding = .utf8
    
    var results: [Tweet] = []
    
    public func searchTweet(
        using query: String,
        username: String? = nil,
        near: String? = nil,
        since: String,
        until: String? = nil,
        count: Int = 0,
        refresh: String = "",
        filterLangCode: String? = nil,
        success: TwitterScraperSuccessHandler? = nil,
        progress: TwitterScraperProgressHandler? = nil,
        failure: HTTPRequest.FailureHandler? = nil) {
        
        guard (count > 0 && results.count < count) || count == 0 else {
            
            success?(results, nil)
            
            return
        }
        
        let JSONSwifterDownloadProgressHandler: HTTPRequest.DownloadProgressHandler = { [weak self] data, received, expected, response in
            
            progress?([], 0.0)

        }
        
        let JSONSwifterSuccessHandler: HTTPRequest.SuccessHandler = { data, response in
            DispatchQueue.global(qos: .utility).async {
                do {
                    let jsonData = try JSON(data: data)
                    let refreshCursor: String = jsonData.dictionaryValue["min_position"]?.string ?? refresh
                    
                    guard let items = jsonData.dictionaryValue["items_html"] else { return }
                    
                    let doc: Document = try SwiftSoup.parse(items.string ?? "")
                    let elesText = try doc.select("div.js-tweet-text-container")
                    let elesTime = try doc.select("span.js-short-timestamp")
                    let elesLang = try? doc.select("p.js-tweet-text")
                    
                    if elesText.count == 0 {
                        
                        success?(self.results, response)
                    } else {

                        for (index, ele) in elesText.enumerated() {
                            guard index < count else { break }
                            
                            let text: String = (try? ele.text()) ?? ""
                            let time: String = elesTime.array().count > index ? (try? elesTime.array()[index].attr("data-time")) ?? "" : ""
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
                            
                            if filterLangCode == nil || filterLangCode == lang {
                                self.results.append(
                                    Tweet.init(
                                        text: text,
                                        time: time,
                                        lang: lang)
                                )
                            }
                        }
                        
                        self.searchTweet(
                            using: query,
                            since: since,
                            until: until,
                            count: count,
                            refresh: refreshCursor,
                            filterLangCode: filterLangCode,
                            success: success,
                            failure: failure)
                    }
                } catch {
                    DispatchQueue.main.async {
                        if case 200...299 = response.statusCode, data.isEmpty {
                            success?(self.results, response)
                        } else {
                            failure?(error)
                        }
                    }
                }
            }
        }
        
        let path: String = "https://twitter.com/i/search/timeline?f=tweets&q=%@&src=typd&max_position=%@"
       
        let pathData: String = " "+query+" since:"+since+" until:"+(until ?? since)
        
        let finalPath = String(
            format: path,
            pathData.addingPercentEncoding(
                withAllowedCharacters: .urlPathAllowed) ?? "",
            refresh.addingPercentEncoding(
                withAllowedCharacters: .urlPathAllowed) ?? "")
        
        _ = self.get(
            finalPath,
            downloadProgress: JSONSwifterDownloadProgressHandler,
            success: JSONSwifterSuccessHandler,
            failure: failure)
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
