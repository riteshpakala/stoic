import Foundation
import CoreML

public class SentimentOutput: Archiveable {
    public let pos: Double
    public let neg: Double
    public let neu: Double
    public let compound: Double
    public var date: Date = .today
    
    enum CodingKeys: String, CodingKey {
        case pos
        case neg
        case neu
        case compound
        case date
    }
    
    public init(pos: Double,
                neg: Double,
                neu: Double,
                compound: Double,
                date: Date = .today) {
        self.pos = pos
        self.neg = neg
        self.neu = neu
        self.compound = compound
        self.date = date
        super.init()
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let pos: Double = try container.decode(Double.self, forKey: .pos)
        let neg: Double = try container.decode(Double.self, forKey: .neg)
        let neu: Double = try container.decode(Double.self, forKey: .neu)
        let compound: Double = try container.decode(Double.self, forKey: .compound)
        let date: Date = try container.decode(Date.self, forKey: .date)
        
        self.init(pos: pos,
                  neg: neg,
                  neu: neu,
                  compound: compound,
                  date: date)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(pos, forKey: .pos)
        try container.encode(neg, forKey: .neg)
        try container.encode(neu, forKey: .neu)
        try container.encode(compound, forKey: .compound)
        try container.encode(date, forKey: .date)
    }
    
    public var magnitude: Double {
        pos - neg
    }
    
    public var asString: String {
        "[neg: \((neg*100).asInt)% | pos: \((pos*100).asInt)%] // bias: \((neu*100).asInt)%"
    }
    
    public var magnitudeAsString: String {
        "[magnitude: \(magnitude)]"
    }
    
    public var description: String {
        "Sentiment-----\n\(date.asString)------\n[neg: \((neg*100).asInt)% | pos: \((pos*100).asInt)%] // bias: \((neu*100).asInt)%"
    }
    
    public static var zero: SentimentOutput {
        return .init(pos: 0.0, neg: 0.0, neu: 0.0, compound: 0.0)
    }
    
    public static var neutral: SentimentOutput {
        return .init(pos: 0.25, neg: 0.25, neu: 0.5, compound: 0.0)
    }
}

class StoicSentimentModel {
    lazy var model: StoicRNN_10? = {
        try? StoicRNN_10.init(configuration: .init())
    }()
    let maxLength = 24
    let vectorSize = 200
    var lemmatizer = Lemmatizer()
    var stopWords: [String] = ["no", "ve", "needn't", "some", "and", "y", "he", "those", "whom", "theirs", "nor", "my", "yourself", "mightn", "i", "does", "not", "too", "shan't", "did", "have", "until", "after", "yours", "the", "all", "wasn", "don", "hasn", "on", "in", "their", "when", "m", "himself", "won", "our", "which", "then", "be", "because", "hadn", "they", "were", "mustn't", "them", "so", "aren't", "hasn't", "with", "should've", "her", "its", "above", "we", "while", "won't", "wouldn't", "each", "him", "there", "just", "both", "ma", "are", "couldn", "up", "re", "is", "doesn", "you'd", "how", "doing", "themselves", "wouldn", "d", "it", "during", "couldn't", "you'll", "your", "wasn't", "why", "under", "doesn't", "these", "from", "about", "myself", "over", "same", "do", "again", "as", "should", "shan", "now", "was", "don't", "a", "this", "here", "t", "through", "that'll", "than", "s", "can", "ll", "haven", "against", "haven't", "or", "if", "only", "most", "out", "such", "between", "off", "you", "herself", "it's", "been", "ain", "his", "being", "shouldn", "having", "isn't", "mustn", "am", "ourselves", "of", "will", "but", "once", "to", "hadn't", "needn", "itself", "more", "very", "you've", "weren", "she", "own", "mightn't", "any", "for", "has", "who", "me", "an", "didn't", "below", "by", "you're", "further", "didn", "where", "ours", "into", "aren", "shouldn't", "down", "isn", "other", "yourselves", "had", "at", "hers", "before", "weren't", "what", "few", "that", "o", "she's"]
    lazy var wordDictionary: [String: Int] = {
        return try! JSONDecoder().decode(Dictionary<String, Int>.self, from: Data(contentsOf: Bundle.main.url(forResource:"Words", withExtension: "json")!))
    }()
    
    lazy var wordDictionaryKeys: [String] = {
        Array(wordDictionary.keys)
    }()
    
    lazy var classes: [String] = {
        return try! JSONDecoder().decode(Array<String>.self, from: Data(contentsOf: Bundle.main.url(forResource:"Classes", withExtension: "json")!))
    }()
    
    func predict(_ utterance: String, matching: String) -> SentimentOutput? {
        guard shouldInfer(utterance, matching: matching) else { return nil }
        guard let model = self.model else { return nil }
        
        let cleaned = cleanTweet(utterance)
        let words = lemmatizer.lemmatize(text: cleaned).compactMap { $0.0 } //$0.1 for lemma -- $0.0 Do not take lemma but original word !!!
        
        guard words.count > 0 else { return nil }
        
        var embedding = [Int]()
        for word in words {
            let potentialSub: String? = wordDictionaryKeys.first(where: { key in
                
                //Twitter underscore
                let split = word.components(separatedBy: "_")
                
                return !split.filter { split_word in key == split_word }.isEmpty
                
            })
            
            var potentialWordValue: Int? = wordDictionary[word]
            
            if let sub = potentialSub, potentialWordValue == nil {
                potentialWordValue = wordDictionary[sub]
            }
            
            embedding.append(potentialWordValue ?? 0)
        }
        
        //
        
        let maxLengthNumber = NSNumber(value: maxLength)
        
        guard let input_data = try? MLMultiArray(shape:[maxLengthNumber,1,1], dataType:.float32) else {
            fatalError("Unexpected runtime error: input_data")
        }
        
        var input_array: [[Float32]] = .init(repeating: .init(repeating: 0, count: maxLength), count: words.count)
        
        for i in 0..<embedding.count {
            input_array[i][0] = Float32(embedding[i])
        }
        
        guard let gru_data = try? MLMultiArray(shape:[maxLengthNumber], dataType:.float32) else {
            fatalError("Unexpected runtime error: input_data")
        }
        
        for i in 0..<maxLength {
            gru_data[i] = 0
        }
        
        //
        
        
        //MODEL
        var predictions: [[Float]] = []
        for list in input_array {
            for (i, item) in list.enumerated() {
                input_data[i] = NSNumber.init(value: item)
            }
            
            let result = runInference(input_data: input_data, gru: gru_data, model: model)
            
            if let b = try? UnsafeBufferPointer<Float>(result.prediction) {
                let c = Array(b)
                predictions.append(c)
            }
        }
        
        let allValues: [Float] = predictions.flatMap { $0 }
        
        let negatives: [Float] = allValues.enumerated().filter({ ($0.offset + 3) % 3 == 0 }).map { $0.element }
        let neutrals: [Float] = allValues.enumerated().filter({ ($0.offset + 2) % 3 == 0 }).map { $0.element }
        let positives: [Float] = allValues.enumerated().filter({ ($0.offset + 1) % 3 == 0 }).map { $0.element }
        
        let averages: [Float] = [negatives.reduce(0, +)/Float(negatives.count), neutrals.reduce(0, +)/Float(neutrals.count), positives.reduce(0, +)/Float(positives.count)]
        
        return SentimentOutput.init(pos: Double(averages[2]), neg: Double(averages[0]), neu: Double(averages[1]), compound: 0.0)
    }
    
    func runInference(input_data: MLMultiArray, gru: MLMultiArray, model: StoicRNN_10) -> (prediction: MLMultiArray, gru: MLMultiArray) {
        
        let input = StoicRNN_10Input(input1: input_data, gru_23_h_in: gru)
        
        guard let prediction = try? model.prediction(input: input) else {
            fatalError("Unexpected runtime error: prediction")
        }
        
        guard let gru_data = try? MLMultiArray(shape:gru.shape, dataType:.float32) else {
            fatalError("Unexpected runtime error: input_data")
        }
        
        for i in 0..<gru_data.shape[0].intValue {
            gru_data[i] = prediction.gru_23_h_out[i]
        }
        
        return (prediction.output1, gru_data)
    }
    
    func shouldInfer(_ text: String, matching: String) -> Bool {
        let tickerThreshold: Bool = TonalUtilities.Social.getTickers(text).count < 3
        let linkThreshold: Bool = TonalUtilities.Social.getLinks(text).isEmpty || text.count > 24
        let queryExists: Bool = text.lowercased().contains(matching.lowercased())
        
        return tickerThreshold && linkThreshold && queryExists
    }
}



public func cleanTweet(_ text: String) -> String {
    let specialCharacters: [String:String] = [
        "\\x89Û_":"",
        "\\x89ÛÒ":"",
        "\\x89ÛÓ":"",
        "\\x89ÛÏWhen":"When",
        "\\x89ÛÏ":"",
        "China\\x89Ûªs":"China's",
        "let\\x89Ûªs": "let's",
        "\\x89Û÷": "",
        "\\x89Ûª": "",
        "\\x89Û\\x9d": "",
        "å_": "",
        "l\\x89Û¢": "",
        "\\x89Û¢åÊ":"",
        "fromåÊwounds":"from wounds",
        "åÊ":"",
        "åÈ":"",
        "JapÌ_n":"Japan",
        "Ì©":"e",
        "å¨":"",
        "SuruÌ¤":"Suruc",
        "åÇ":"",
        "å£3million":"3 million",
        "åÀ":""]
    
    let contractions1: [String:String] = [
        "he's":"he is",
        "there's":"there is",
        "We're":"We are",
        "That's":"That is",
        "won't":"will not",
        "they're":"they are",
        "Can't":"Cannot",
        "wasn't":"was not",
        "don\\x89Ûªt":"do not",
        "aren't":"are not",
        "isn't":"is not",
        "What's":"What is",
        "haven't":"have not",
        "hasn't":"has not",
        "There's": "There is"]
    
    let contractions2: [String: String] = [
        "He's": "He is",
        "It's": "It is",
        "You're": "You are",
        "I'M": "I am",
        "shouldn't": "should not",
        "wouldn't": "would not"]
    
    let contractions3: [String: String] = [
        "i'm": "I am",
        "I\\x89Ûªm": "I am"]
    
    let contractions4: [String: String] = [
        "I'm": "I am",
        "Isn't": "is not",
        "Here's": "Here is",
        "you've": "you have",
        "you\\x89Ûªve": "you have",
        "we're": "we are",
        "what's": "what is",
        "couldn't": "could not",
        "we've": "we have",
        "it\\x89Ûªs": "it is",
        "doesn\\x89Ûªt": "does not"]
    
    let contractions5: [String: String] = [
        "It\\x89Ûªs": "It is",
        "Here\\x89Ûªs": "Here is",
        "who's": "who is",
        "I\\x89Ûªve": "I have",
        "y'all": "you all",
        "can\\x89Ûªt": "cannot",
        "would've": "would have",
        "it'll": "it will",
        "we'll": "we will",
        "wouldn\\x89Ûªt": "would not",
        "We've": "We have",
        "he'll": "he will",
        "Y'all": "You all",
        "Weren't": "Were not",
        "Didn't": "Did not",
        "they'll": "they will",
        "they'd": "they would",
        "DON'T": "DO NOT",
        "That\\x89Ûªs": "That is",
        "they've": "they have",
        "i'd": "I would",
        "should've": "should have",
        "You\\x89Ûªre": "You are",
        "where's": "where is",
        "Don\\x89Ûªt": "Do not",
        "we'd": "we would",
        "i'll": "I will"]
    
    let contractions6: [String: String] = [
        "weren't": "were not",
        "They're": "They are",
        "Can\\x89Ûªt": "Cannot",
        "you\\x89Ûªll": "you will",
        "I\\x89Ûªd": "I would",
        "let's": "let us",
        "it's": "it is",
        "can't": "cannot",
        "don't": "do not",
        "you're": "you are",
        "i've": "I have",
        "that's": "that is",
        "i'll": "I will",
        "doesn't": "does not",
        "i'd": "I would",
        "didn't": "did not",
        "ain't": "am not",
        "you'll": "you will",
        "I've": "I have",
        "Don't": "do not",
        "I'll": "I will"]
        
    let contractions7: [String: String] = [
        "I'd": "I would",
        "Let's": "Let us",
        "you'd": "You would",
        "It's": "It is",
        "Ain't": "am not",
        "Haven't": "Have not",
        "Could've": "Could have",
        "youve": "you have",
        "donå«t": "do not",]
    
    let entity: [String:String] = [
        "&gt;": ">",
        "&lt;": "<",
        "&amp;": "&"]
    
    let types: [String:String] = [
        "w/e": "whatever",
        "w/": "with",
        "USAgov": "USA government",
        "recentlu": "recently",
        "Ph0tos": "Photos",
        "amirite": "am I right",
        "exp0sed": "exposed",
        "<3": "love",
        "amageddon": "armageddon",
        "Trfc": "Traffic",
        "8/5/2015": "2015-08-05",
        "WindStorm": "Wind Storm",
        "8/6/2015": "2015-08-06",
        "10:38PM": "10:38 PM",
        "10:30pm": "10:30 PM",
        "16yr": "16 year",
        "lmao": "laughing my ass off",
        "TRAUMATISED": "traumatized"]
        
     let acronyms: [String:String] = [
        "MH370": "Malaysia Airlines Flight 370",
        "mÌ¼sica": "music",
        "okwx": "Oklahoma City Weather",
        "arwx": "Arkansas Weather",
        "gawx": "Georgia Weather",
        "scwx": "South Carolina Weather",
        "cawx": "California Weather",
        "tnwx": "Tennessee Weather",
        "azwx": "Arizona Weather",
        "alwx": "Alabama Weather",
        "wordpressdotcom": "wordpress",
        "usNWSgov": "United States National Weather Service",
        "Suruc": "Sanliurfa"]
        
     let grouping: [String:String] = [
        "Bestnaijamade": "bestnaijamade",
        "SOUDELOR": "Soudelor"]
       
     let other: [String:String] = [
        "\\$\\w*": "",
        "^RT[\\s]+": "",
        "https?:\\/\\/.*[\r\n]*": "",
        "#": "",
        "<.*?>": "",
        "\\w*\\d\\w*": ""]
    
    let all: [[String:String]] = [specialCharacters + contractions1 + contractions2 + contractions3 + contractions4 + contractions5 + contractions6 + contractions7 + entity + types + acronyms + grouping + other]
    
    var currentText: String = text
    for item in all {
        for key in item.keys {
            if let value = item[key] {
                let regex = re.compile(key)
                currentText = regex.sub(value, currentText)
            }
        }
    }
    
    return currentText
}

func +<Key,Value>(left: [Key: Value], right: [Key: Value]) -> [Key: Value] {
    var map: [Key: Value] = [:]
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}

func +=<Key, Value> (lhs: inout [Key: Value], rhs: [Key: Value]) {
    rhs.forEach{ lhs[$0] = $1 }
}
