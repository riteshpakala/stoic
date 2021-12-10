import Foundation

extension Cryptowatcher {
    /**
     Fetches a list of all supported exchanges.
     
     *Example:* <https://api.cryptowat.ch/exchanges>
     
     - Returns: A `Promise` for a `GetExchangeIndex` representing the response.
     */
    func getExchangeIndex() -> Promise<CryptoServiceModels.GetExchangeIndex> {
        let url = "\(baseURL)/exchanges"
        return fetch(url, type: CryptoServiceModels.GetExchangeIndex.self).then(decodeResult)
    }
    
    /**
     Fetches a single exchange, with associated routes.
     
     *Example:* <https://api.cryptowat.ch/exchanges/kraken>
     
     - Parameter exchange: A `String` representing the exchange.
     - Returns: A `Promise` for a `GetExchange` representing the response.
     */
    func getExchange(exchange: String) -> Promise<CryptoServiceModels.GetExchange> {
        let url = "\(baseURL)/exchanges/exchange"
        return fetch(url, type: CryptoServiceModels.GetExchange.self).then(decodeResult)
    }
    
    /**
     Fetches a single exchange, with associated routes.
     
     *Example:* <https://api.cryptowat.ch/exchanges/kraken>
     
     - Parameter exchange: An `Exchange.Symbol` representing the exchange.
     - Returns: A `Promise` for a `GetExchange` representing the response.
     */
    func getExchange(exchange: CryptoServiceModels.Exchange.Symbol) -> Promise<CryptoServiceModels.GetExchange> {
        return getExchange(exchange: exchange.rawValue)
    }
}
