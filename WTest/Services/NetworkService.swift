//
//  NetworkService.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import UIKit

// MARK: - typealias

#if PRIMARY
typealias FetchResult<T> = (Result<T, Error>) -> Void
#else
typealias FetchResult<T> = (Result<[T], Error>) -> Void
#endif

// MARK: - Protocols
// Envisioned the network service using protocols to facilitate tests implementation and mocking in the future.

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint, type: T.Type, completion: @escaping FetchResult<T>)
}

// MARK: - Requests

class NetworkService: NetworkServiceProtocol {

    /// Generic fetch data function
    /// - Parameters:
    ///   - endpoint: All the available URLs come from the enum Endpoint.
    ///   - type: The type is generic. It allows decoding any array or object.
    ///   - completion: It sends the data or the error at the end of the data task.
    func fetch<T: Decodable>(_ endpoint: Endpoint, type: T.Type, completion: @escaping FetchResult<T>) {
        guard let url = endpoint.url else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                guard let data = data else { return }
                #if PRIMARY
                let content = try JSONDecoder().decode(T.self, from: data)
                #else
                let content = try JSONDecoder().decode([T].self, from: data)
                #endif
                
                completion(.success(content))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
