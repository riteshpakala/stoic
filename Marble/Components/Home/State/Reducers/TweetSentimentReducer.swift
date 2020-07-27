//
//  TweetSentimentReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 5/23/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
private let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
private var tagger: NSLinguisticTagger = .init(
  tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"),
  options: Int(options.rawValue)
)

func features(from text: String) -> [String: Double] {
  var wordCounts = [String: Double]()

  tagger.string = text
  let range = NSRange(location: 0, length: text.utf16.count)

  // Tokenize and count the sentence
  tagger.enumerateTags(in: range, scheme: .nameType, options: options) { _, tokenRange, _, _ in
    let token = (text as NSString).substring(with: tokenRange).lowercased()
    // Skip small words
    guard token.count >= 3 else {
      return
    }

    if let value = wordCounts[token] {
      wordCounts[token] = value + 1.0
    } else {
      wordCounts[token] = 1.0
    }
  }

  return wordCounts
}
struct TweetSentimentReducer: Reducer {
    typealias ReducerEvent = HomeEvents.TweetSentimentTestEvent
    typealias ReducerState = HomeState
    
    
    func reduce(
        event: ReducerEvent,
        state: inout HomeState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
//        let scraper = TwitterScraper()
//        scraper.searchTweet(
//            using: "Valorant",
//            username: nil,
//            near: nil,
//            since: "2020-06-01",
//            until: "2020-06-02",
//            count: 120,
//
//        success:  { (results, reponse) in
//            for result in results {
//                print(result.text)
//                print("########################")
//            }
//        },
//
//        failure: {  error in
//
//        })
//        VaderSentiment.test()
        state.test+=1
    }
    
    func predictionScore(
        with tweets : [SentimentPolarityInput],
        _ model: SentimentPolarity) -> Double {

        var score: Double = 0.0
        do{
            let predictions = try model.predictions(inputs: tweets)
            
            
            for (prediction) in predictions {
                if prediction.classLabel == "Pos"{
                    score += 1.0
                } else if prediction.classLabel == "Neutral" {
                    score += 0.5
                }
                else if prediction.classLabel == "Neg"{
                    score -= 1.0
                }
                
                print("{TEST} POS: \(prediction.classProbability["Pos"]) x NEG: \(prediction.classProbability["Neg"]) x NEUTRAL: \(prediction.classProbability["Neutral"])")
                score  *=  (prediction.classProbability[prediction.classLabel] ?? 1.0)
            }
        }catch{
            print("error predicting \(error)")
        }
        return score
    }
}
