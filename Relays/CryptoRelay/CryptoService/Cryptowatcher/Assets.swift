import Foundation

extension CryptoServiceModels {
    /// An asset can be a crypto or fiat currency.
    struct Asset: Codable {
        let symbol: String
        let name: String
        let fiat: Bool
        let route: URL?
        let markets: Markets?
        
        /// Represents the response structure containing `base` and `quote` `Markets`
        struct Markets: Codable {
            let base: [Market]
            let quote: [Market]
        }
        
        var toString: String {
            """
            [\(symbol) : \(name)]
            Base //
            \(markets?.base.first?.toString)
            Quote //
            \(markets?.quote.first?.toString)
            """
        }
    }

    /// Represents a response from `getAssetIndex`
    struct GetAssetIndex: Codable {
        let result: [Asset]
        let allowance: Allowance
    }

    /// Represents a response from `getAsset`
    struct GetAsset: Codable {
        let result: Asset
        let allowance: Allowance
    }
}
