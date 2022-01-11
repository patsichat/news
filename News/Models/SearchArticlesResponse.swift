//
//  SearchArticlesResponse.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/11/22.
//

struct SearchArticlesResponse: Codable {
    let response: Response
    struct Response: Codable {
        let docs: [Article]
    }
    struct Article: Codable {
        let headline: Headline
        let abstract: String
    }
    struct Headline: Codable {
        let main: String
    }
}
