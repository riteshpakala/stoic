import Foundation

extension Cryptowatcher {
    /**
     Fetches all pairs (in no particular order).
     
     *Example:* <https://api.cryptowat.ch/pairs>
     
     - Returns: A `Promise` for a `GetPairIndex` representing the response.
     */
    func getPairIndex() -> Promise<CryptoModels.GetPairIndex> {
        let url = "\(baseURL)/pairs"
        return fetch(url, type: CryptoModels.GetPairIndex.self).then(decodeResult)
    }
    
    /**
     Fetches a single pair. Lists all `Markets` for this pair.
     
     *Example:* <https://api.cryptowat.ch/pairs/ethbtc>
     
     - Parameter pair: A `String` representing the pair (ex. `"ethbtc"`).
     - Returns: A `Promise` for a `GetPair` representing the response.
     */
    func getPair(pair: String) -> Promise<CryptoModels.GetPair> {
        let url = "\(baseURL)/pairs/\(pair)"
        return fetch(url, type: CryptoModels.GetPair.self).then(decodeResult)
    }
}
