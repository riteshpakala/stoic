import Foundation

extension Cryptowatcher {
    /**
     Fetches a list of all supported exchanges.
     
     *Example:* <https://api.cryptowat.ch/exchanges>
     
     - Returns: A `Promise` for a `GetExchangeIndex` representing the response.
     */
    func getExchangeIndex() -> Promise<CryptoModels.GetExchangeIndex> {
        let url = "\(baseURL)/exchanges"
        return fetch(url, type: CryptoModels.GetExchangeIndex.self).then(decodeResult)
    }
    
    /**
     Fetches a single exchange, with associated routes.
     
     *Example:* <https://api.cryptowat.ch/exchanges/kraken>
     
     - Parameter exchange: A `String` representing the exchange.
     - Returns: A `Promise` for a `GetExchange` representing the response.
     */
    func getExchange(exchange: String) -> Promise<CryptoModels.GetExchange> {
        let url = "\(baseURL)/exchanges/exchange"
        return fetch(url, type: CryptoModels.GetExchange.self).then(decodeResult)
    }
    
    /**
     Fetches a single exchange, with associated routes.
     
     *Example:* <https://api.cryptowat.ch/exchanges/kraken>
     
     - Parameter exchange: An `Exchange.Symbol` representing the exchange.
     - Returns: A `Promise` for a `GetExchange` representing the response.
     */
    func getExchange(exchange: CryptoModels.Exchange.Symbol) -> Promise<CryptoModels.GetExchange> {
        return getExchange(exchange: exchange.rawValue)
    }
}
