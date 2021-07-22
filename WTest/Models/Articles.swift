//
//  Articles.swift
//  WTest
//
//  Created by Leonardo Bilia on 22/07/21.
//

import Foundation

struct Article: Codable {
    let items: [Item]

    struct Item: Codable {
        let id: String
        let title: String
        let publishedAt: String
        let hero: String?
        let author: String
        let summary: String?
        let body: String
        
        private enum CodingKeys: String, CodingKey {
            case id, title, hero, author, summary, body
            case publishedAt = "published-at"
        }
    }
}
