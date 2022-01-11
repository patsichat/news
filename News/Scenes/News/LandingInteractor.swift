//
//  LandingInteractor.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

protocol LandingInteractorInterface {
    func getMostViewedArticles(request: Landing.GetMostViewedArticles.Request)
    func setFilterSection(request: Landing.FilterSection.Request)
    func searchActicle(request: Landing.SearchArticle.Request)
}

class LandingInteractor: LandingInteractorInterface {
    var presenter: LandingPresenterInterface!
    var worker: NewsWorker?
    private var mostViewedArticles: [MostViewedArticlesResponse.Article] = []
    private var selectedSection: String?
    private var searchedArticles: [SearchArticlesResponse.Article] = []
    func getMostViewedArticles(request: Landing.GetMostViewedArticles.Request) {
        worker?.getMostViewedArticles(period: request.period) { [weak self] result in
            switch result {
            case .success(let data):
                self?.mostViewedArticles = data
                let response = Landing.GetMostViewedArticles.Response(result: data)
                self?.presenter.presentMostViewedArticles(response: response)
            case .failure(let error):
                print(error)
            }
        }

    }
    func setFilterSection(request: Landing.FilterSection.Request) {
        selectedSection = request.section
        let section = request.section
        var result = mostViewedArticles
        if let section = section {
            result = result.filter({ $0.section == section })
        }
        let response = Landing.FilterSection.Response(section: section,
                                                      result: result)
        presenter.presentFilterSection(response: response)
    }
    func searchActicle(request: Landing.SearchArticle.Request) {
        worker?.searchActicles(request.searchString, { [weak self] result in
            switch result {
            case .success(let data):
                self?.searchedArticles = data
                let response = Landing.SearchArticle.Response(result: data)
                self?.presenter.presentSearchActicle(response: response)
            case .failure(let error):
                print(error)
            }
        })
    }
}
