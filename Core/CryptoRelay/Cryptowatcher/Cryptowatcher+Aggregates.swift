import Foundation
import Combine

extension Cryptowatcher {
    /**
     Fetches the current price for all supported markets.
     
     *Note: Some values may be out of date by a few seconds.*
    
     *Example:* <https://api.cryptowat.ch/markets/prices>
    
     - Returns: A `Promise` for a `GetAggregatePrices` representing the response.
    */
    func getAggregatePrices() -> Promise<CryptoModels.GetAggregatePrices> {
        let url = "\(baseURL)/markets/prices"
        return fetch(url, type: CryptoModels.GetAggregatePrices.self).then(decodeResult)
    }
    
    /**
     Fetches the market summary for all supported markets.
     
     *Note: Some values may be out of date by a few seconds.*
     
     *Example:* <https://api.cryptowat.ch/markets/summaries>
     
     - Returns: A `Promise` for a `GetAggregateSummaries` representing the response.
     */
    func getAggregateSummaries() -> Promise<CryptoModels.GetAggregateSummaries> {
        let url = "\(baseURL)/markets/summaries"
        return fetch(url, type: CryptoModels.GetAggregateSummaries.self).then(decodeResult)
    }
    
    func getAggregateSummariesPublisher() -> AnyPublisher<CryptoFetchResult<CryptoModels.GetAggregateSummaries>, URLError>? {
        let url = "\(baseURL)/markets/summaries"
        return fetchPublisher(url, type: CryptoModels.GetAggregateSummaries.self)
    }
}
