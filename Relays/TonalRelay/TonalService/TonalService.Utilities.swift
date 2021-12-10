//
//  TonalService.SocialUtilities.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//

import Foundation

struct TonalUtilities {
    struct Social {
        public static func getTickers(_ text: String) -> [String] {
            let regex = re.compile("[$][A-Za-z][\\S]*")
            let found = regex.findall(text)
            return found
        }
        
        public static func getLinks(_ text: String) -> [String] {
            let types: NSTextCheckingResult.CheckingType = .link

            let detector = try? NSDataDetector(types: types.rawValue)

            guard let detect = detector else {
               return []
            }

            let matches = detect.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))

            return matches.compactMap { $0.url?.absoluteString }
        }
    }
}
