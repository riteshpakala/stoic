import Foundation

extension Cryptowatcher {
    /**
     Fetches all assets (in no particular order).
     
     *Example:* <https://api.cryptowat.ch/assets>
     
     - Returns: A `Promise` for a `GetAssetIndex` representing the response.
     */
    func getAssetIndex() -> Promise<CryptoModels.GetAssetIndex> {
        let url = "\(baseURL)/assets"
        return fetch(url, type: CryptoModels.GetAssetIndex.self).then(decodeResult)
    }
    
    /**
     Fetches a single asset. Lists all `Markets` which have this asset as a base or quote.
     
     *Example:* <https://api.cryptowat.ch/assets/btc>
     
     - Parameter asset: A `String` representing an `Asset`.
     - Returns: A `Promise` for a `GetAsset` representing the response.
     */
    func getAsset(asset: String) -> Promise<CryptoModels.GetAsset> {
        let url = "\(baseURL)/assets/\(asset)"
        return fetch(url, type: CryptoModels.GetAsset.self).then(decodeResult)
    }
}
