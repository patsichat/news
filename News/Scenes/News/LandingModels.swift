//
//  LandingModels.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

struct Landing {
    struct GetMostViewedArticles {
        struct Request {
            let period: Period
            enum Period: String {
                case oneDay = "1"
                case sevenDays = "7"
                case thirtyDays = "30"
            }
        }
        struct Response {
            let result: [MostViewedArticlesResponse.Article]
        }
        struct ViewModel {
            let content: [DisplayedArticle]
        }
        struct DisplayedArticle {
            let title: String
            let abstract: String
        }
    }
}
