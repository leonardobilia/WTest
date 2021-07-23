//
//  Comment.swift
//  WTest
//
//  Created by Leonardo Bilia on 23/07/21.
//

import Foundation

struct Comment: Codable {
    let id: String
    let articleID: String
    let publishedAt: String
    let name: String
    let avatar: String
    let body: String

    private enum CodingKeys: String, CodingKey {
        case id, name, avatar, body
        case articleID = "articleId"
        case publishedAt = "published-at"
    }
}
