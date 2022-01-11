//
//  MostViewedArticlesResponse.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

struct MostViewedArticlesResponse: Codable {
    let results: [Article]
    struct Article: Codable {
        let title: String
        let abstract: String
        let section: String
    }
}
