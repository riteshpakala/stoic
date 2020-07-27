//
//  Translate.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/26/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public class Translate: NSObject {
    public typealias TranslateSuccessHandler = (String, _ response: HTTPURLResponse?) -> Void
    public typealias TranslateFailureHandler = (_ error: Error) -> Void
    
    let dataEncoding: String.Encoding = .utf8
    
    var results: [Tweet] = []
    
    public func convert(
        using query: String,
        baseLangCode: String = "en",
        targetLangCode: String,
        success: TranslateSuccessHandler? = nil,
        failure: TranslateFailureHandler? = nil) {
        
        print("{TEST} \(targetLangCode)")
        let HTTPSuccessHandler: HTTPRequest.SuccessHandler = { data, response in
            DispatchQueue.global(qos: .utility).async {
                print("{TEST} \(data.count)")
                guard let translation = String.init(
                    data: data,
                    encoding: self.dataEncoding) else { return }
                print("{TEST} from: \(query)")
                print("{TEST} to: \(translation)")
                
                success?(translation, response)
            }
        }
        
        let path: String = "https://mymemory.translated.net/api/get?q=%@&langpair=%@|%@"
        let finalPath: String = .init(
            format: path,
            query.stripNewLines.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? "",
            baseLangCode.addingPercentEncoding(
                withAllowedCharacters: .urlPathAllowed) ?? "",
            targetLangCode.addingPercentEncoding(
                withAllowedCharacters: .urlPathAllowed) ?? "")
        print("{TEST} \(finalPath)")
        guard let url = URL(string: finalPath) else { print("{TEST} invalid url"); return }
        print("{TEST} starting translation")
        let request = HTTPRequest(url: url, method: .GET, parameters: [:])
        request.successHandler = HTTPSuccessHandler
        request.failureHandler = failure
        request.dataEncoding = self.dataEncoding
        
        request.headers = ["User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Charset": "ISO-8859-1,utf-8;q=0.7,*;q=0.3",
        "Accept-Encoding": "none",
        "Accept-Language": "en-US,en;q=0.8",
        "Connection": "keep-alive"]
            
            
//            ["Host": "twitter.com",
//        "User-Agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36",
//        "Accept":"application/json, text/javascript, */*; q=0.01",
//        "Accept-Language":"de,en-US;q=0.7,en;q=0.3",
//        "X-Requested-With":"XMLHttpRequest",
//        "Referer": url.relativeString,
//        "Connection":"keep-alive"];
        
        request.start()
        
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
