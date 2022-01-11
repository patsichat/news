//
//  MostViewedWorker.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

protocol NewsStoreProtocol {
    func getMostViewedArticles(_ period: Landing.GetMostViewedArticles.Request.Period,_ completion: @escaping (Result<[MostViewedArticlesResponse.Article]>) -> Void)
    func searchActicles(_ searchString: String, _ completion: @escaping (Result<[SearchArticlesResponse.Article]>) -> Void)
}

class NewsWorker {
    var store: NewsStoreProtocol

    init(store: NewsStoreProtocol) {
        self.store = store
    }
    func getMostViewedArticles(period: Landing.GetMostViewedArticles.Request.Period, completion: @escaping (Result<[MostViewedArticlesResponse.Article]>) -> Void) {
        store.getMostViewedArticles(period, completion)
    }
    func searchActicles(_ searchString: String, _ completion: @escaping (Result<[SearchArticlesResponse.Article]>) -> Void) {
        store.searchActicles(searchString, completion)
    }
}
