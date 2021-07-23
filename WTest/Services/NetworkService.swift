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

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint, type: T.Type, completion: @escaping FetchResult<T>)
}

// MARK: - Requests

class NetworkService: NetworkServiceProtocol {
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
