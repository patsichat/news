//
//  NewsRestStore.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

import Alamofire

final class NewsRestStore: NewsStoreProtocol {
    private let apikey = "qibagtOByqTUrBTJFn051N80CW2rbfnG"
    func getMostViewedArticles(_ period: Landing.GetMostViewedArticles.Request.Period,_ completion: @escaping (Result<[MostViewedArticlesResponse.Article]>) -> Void) {
        let request = AF.request("https://api.nytimes.com/svc/mostpopular/v2/viewed/\(period.rawValue).json", parameters: ["api-key": apikey])
        request.responseDecodable(of: MostViewedArticlesResponse.self) { (response) in
            guard let value = response.value else { return }
            completion(.success(result: value.results))
          }
        
    }
}
