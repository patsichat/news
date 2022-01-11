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
            let sections: [String]
        }
        struct DisplayedArticle {
            let title: String
            let abstract: String
        }
    }

    struct FilterSection {
        struct Request {
            let section: String?
        }
        struct Response {
            let section: String?
            let result: [MostViewedArticlesResponse.Article]
        }
        struct ViewModel {
            let section: String
            let content: [GetMostViewedArticles.DisplayedArticle]
        }
    }

    struct SearchArticle {
        struct Request {
            let searchString: String
        }
        struct Response {
            let result: [SearchArticlesResponse.Article]
        }
        struct ViewModel {
            let content: [GetMostViewedArticles.DisplayedArticle]
        }
    }

    struct SelectDetail {
        struct Request {
            let index: Int
        }
        struct Response {}
        struct ViewModel {}
    }

    enum DisplayMode {
        case mostViewed
        case search
    }
}
