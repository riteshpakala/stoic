import Foundation
import Combine

extension Cryptowatcher {
    /**
     Fetches all assets (in no particular order).
     
     *Example:* <https://api.cryptowat.ch/assets>
     
     - Returns: A `Promise` for a `GetAssetIndex` representing the response.
     */
    func getAssetIndex() -> Promise<CryptoServiceModels.GetAssetIndex> {
        let url = "\(baseURL)/assets"
        return fetch(url, type: CryptoServiceModels.GetAssetIndex.self).then(decodeResult)
    }
    
    func getAssetIndexPublisher() -> AnyPublisher<CryptoFetchResult<CryptoServiceModels.GetAssetIndex>, URLError>? {
        let url = "\(baseURL)/assets"
        return fetchPublisher(url, type: CryptoServiceModels.GetAssetIndex.self)
    }
    
    var getAssetIndexRoute: String {
        "\(baseURL)/assets"
    }
    
    /**
     Fetches a single asset. Lists all `Markets` which have this asset as a base or quote.
     
     *Example:* <https://api.cryptowat.ch/assets/btc>
     
     - Parameter asset: A `String` representing an `Asset`.
     - Returns: A `Promise` for a `GetAsset` representing the response.
     */
    func getAsset(asset: String) -> Promise<CryptoServiceModels.GetAsset> {
        let url = "\(baseURL)/assets/\(asset)"
        return fetch(url, type: CryptoServiceModels.GetAsset.self).then(decodeResult)
    }
    
    func getAssetPublisher(asset: String) -> AnyPublisher<CryptoFetchResult<CryptoServiceModels.GetAsset>, URLError>? {
        let url = "\(baseURL)/assets/\(asset)"
        return fetchPublisher(url, type: CryptoServiceModels.GetAsset.self)
    }
}
