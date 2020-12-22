import Foundation
import Combine

/// A protocol which is extended to add fetching and decoding capabilities.
protocol CryptoFetchable {}

/// Represents errors that can occur while fetching.
enum CryptoFetchableError: Swift.Error {
    /// The `URL` could not be parsed from a string
    case malformedURL
}

/// Allows us to utilize the specified `Decodable` `type` in `Promises` along with the response `data`.
struct CryptoFetchResult<T: Decodable> {
    let data: Data?
    let type: T.Type
    
    public static var empty: CryptoFetchResult<String> {
        return .init(data: "error".data(using: .utf8), type: String.self)
    }
}

extension CryptoFetchable {
    /**
     Peforms a network request to fetch data.
     
     - Parameters:
        - url: The `URL` from which to fetch data.
        - type: The `Decodable` type to pass along.
     
     - Returns: A `Promise` for a `FetchResult<T>`.
     */
    func fetch<T: Decodable>(_ url: URL, type: T.Type) -> Promise<CryptoFetchResult<T>> {
        return Promise { resolve, reject in
            
            let dataTask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                
                if let error = error {
                    reject(error)
                    return
                }
                
                let result = CryptoFetchResult(data: data, type: type)
                
                resolve(result)
            })
            
            dataTask.resume()
        }
    }
    
    /**
     Peforms a network request to fetch data.
     
     - Parameters:
     - url: The `string` representing the `URL` from which to fetch data.
     - type: The `Decodable` type to pass along.
     
     - Returns: A `Promise` for a `FetchResult<T>`.
     */
    func fetch<T: Decodable>(_ url: String, type: T.Type) -> Promise<CryptoFetchResult<T>> {
        guard let url = URL(string: url) else {
            return Promise.reject(CryptoFetchableError.malformedURL)
        }
        return fetch(url, type: type)
    }
    
    func fetchPublisher<T: Decodable>(_ url: String, type: T.Type) -> AnyPublisher<CryptoFetchResult<T>, URLError>? {
        guard let url = URL(string: url) else {
            return nil
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .compactMap {
                CryptoFetchResult<T>.init(data: $0.data, type: type)
            }.eraseToAnyPublisher()
    }
    
    /**
     Decodes JSON data as the specified `Decodable` type in the result.
     
     This function can be chained onto a `fetch` call like so:
     
     `fetch(myURL, MyType.self).then(decodeResult)`
     
     - Parameter result: Contains the data and the type for which the data will be decoded.
     - Returns: A `Promise` for JSON data decoded as the specified type.
     */
    func decodeResult<T>(result: CryptoFetchResult<T>) -> Promise<T> {
        return Promise { resolve, reject in
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(result.type, from: result.data ?? Data())
                resolve(result)
            } catch let error {
                reject(error)
            }
        }
    }
}
