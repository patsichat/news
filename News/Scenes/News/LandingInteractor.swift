//
//  LandingInteractor.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

protocol LandingInteractorInterface {
    func getMostViewedArticles(request: Landing.GetMostViewedArticles.Request)
}

class LandingInteractor: LandingInteractorInterface {
    var presenter: LandingPresenterInterface!
    var worker: NewsWorker?

    func getMostViewedArticles(request: Landing.GetMostViewedArticles.Request) {
        worker?.getMostViewedArticles(period: request.period) { [weak self] result in
            switch result {
            case .success(let data):
                let response = Landing.GetMostViewedArticles.Response(result: data)
                self?.presenter.presentMostViewedArticles(response: response)
            case .failure(let error):
                print(error)
            }
        }

    }
}
