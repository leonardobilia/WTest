//
//  NetworkService.swift
//  WTest
//
//  Created by Leonardo Bilia on 21/07/21.
//

import UIKit

enum EndPoint: String {
    case zipcodes = "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv"
    case mainArticles = "https://5bb1cd166418d70014071c8e.mockapi.io/mobile/1-1/articles"
    case secondaryArticles = "https://5badefb9a65be000146763a4.mockapi.io/mobile/1-0/articles"
}

// MARK: - Protocols

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: EndPoint, limit: Int, page: Int, type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

// MARK: - Requests

class NetworkService: NetworkServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: EndPoint, limit: Int, page: Int, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint.rawValue + "?limit=\(limit)&page=\(page)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                guard let data = data else { return }
                let content = try JSONDecoder().decode(T.self, from: data)
                completion(.success(content))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
