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
    func setSelectDetail(request: Landing.SelectDetail.Request)
    var urlString: String? { get }
}

class LandingInteractor: LandingInteractorInterface {
    var presenter: LandingPresenterInterface!
    var worker: NewsWorker?

    private var displayMode: Landing.DisplayMode = .mostViewed
    private var mostViewedArticles: [MostViewedArticlesResponse.Article] = []
    private var selectedSection: String?
    private var searchedArticles: [SearchArticlesResponse.Article] = []
    var urlString: String?

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
        displayMode = .mostViewed
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
        displayMode = .search
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

    func setSelectDetail(request: Landing.SelectDetail.Request) {
        let index = request.index
        switch displayMode {
        case .mostViewed:
            var result = mostViewedArticles
            if let section = selectedSection {
                result = result.filter({ $0.section == section })
            }
            urlString = result[index].url
        case .search:
            urlString = searchedArticles[index].url
        }
        let response = Landing.SelectDetail.Response()
        presenter.presentSelectDetail(response: response)
    }
}
