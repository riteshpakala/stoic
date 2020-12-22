import Foundation

extension CryptoModels {
    /**
     Represents a `getAggregatePrices` response.
     
     *Markets are identified by a slug, which is the exchange name and currency pair concatenated with a colon, like so:
     `gdax:btcusd`*
     
     Example `result`: `["bitfinex:bfxbtc": 0.00067133]`
     */
    struct GetAggregatePrices: Codable {
        let result: Dictionary<String, Double>
        let allowance: Allowance
    }

    /**
     Represents a `getAggregateSumaries` response.
     
     *Markets are identified by a slug, which is the exchange name and currency pair concatenated with a colon, like so:
     `gdax:btcusd`*
     
     Example `result`: `["bitfinex:bfxbtc": [...]]`
     */
    struct GetAggregateSummaries: Codable {
        let result: Dictionary<String, MarketSummary>
        let allowance: Allowance
    }
}
