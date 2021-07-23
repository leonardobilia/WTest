//
//  Endpoint.swift
//  WTest
//
//  Created by Leonardo Bilia on 23/07/21.
//

import Foundation

enum Endpoint {
    case zipcodes
    case secondaryArticles(limit: Int, page: Int)
    
    #if PRIMARY
    case articles(limit: Int, page: Int)
    #else
    case articles(limit: Int, page: Int)
    case comments(id: String, limit: Int, page: Int)
    #endif
}

extension Endpoint {
    var url: URL? {
        switch self {
        case .zipcodes:
            return URL(string: "https://api.myapp.com/")
    
        case .secondaryArticles(let limit, let page):
            return URL(string: "https://5badefb9a65be000146763a4.mockapi.io/mobile/1-0/articles?limit=\(limit)&page=\(page)")
          
        #if PRIMARY
        case .articles(let limit, let page):
            return URL(string: "https://5bb1cd166418d70014071c8e.mockapi.io/mobile/1-1/articles?limit=\(limit)&page=\(page)")
        #else
        case .articles(let limit, let page):
            return URL(string: "https://5bb1d1e66418d70014071c9c.mockapi.io/mobile/2-0/articles?limit=\(limit)&page=\(page)")
            
        case .comments(let id, let limit, let page):
            return URL(string: "https://5bb1d1e66418d70014071c9c.mockapi.io/mobile/2-0/articles/\(id)/comments?limit=\(limit)&page=\(page)")
        #endif
        }
    }
}
