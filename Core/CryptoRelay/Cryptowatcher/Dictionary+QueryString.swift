import Foundation

extension Dictionary {
    /// Turns a `Dictionary` of parameters into a `querystring`.
    var queryStringCrypto: String? {
        let qs = self.map({ key, value in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        return qs.isEmpty ? nil : qs
    }
}
