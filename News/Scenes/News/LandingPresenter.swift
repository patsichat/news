//
//  LandingPresenter.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

protocol LandingPresenterInterface {
    func presentMostViewedArticles(response: Landing.GetMostViewedArticles.Response)
    func presentFilterSection(response: Landing.FilterSection.Response)
    func presentSearchActicle(response: Landing.SearchArticle.Response)
    func presentSelectDetail(response: Landing.SelectDetail.Response)
}

class LandingPresenter: LandingPresenterInterface {
    weak var viewController: LandingViewControllerInterface!

    func presentMostViewedArticles(response: Landing.GetMostViewedArticles.Response) {
        let content = response.result.map({ Landing.GetMostViewedArticles.DisplayedArticle(title: $0.title, abstract: $0.abstract) })
        let sections = Set(response.result.map({ $0.section }))
        let viewModel = Landing.GetMostViewedArticles.ViewModel(content: content, sections: Array(sections))
        viewController.displayMostViewedArticles(viewModel: viewModel)
    }

    func presentFilterSection(response: Landing.FilterSection.Response) {
        var displayedSection = "All"
        if let section = response.section {
            displayedSection = section
        }
        let content = response.result.map({ Landing.GetMostViewedArticles.DisplayedArticle(title: $0.title, abstract: $0.abstract) })
        let viewModel = Landing.FilterSection.ViewModel(section: displayedSection,
                                                        content: content)
        viewController.displayFilterSection(viewModel: viewModel)
    }

    func presentSearchActicle(response: Landing.SearchArticle.Response) {
        let content = response.result.map({ Landing.GetMostViewedArticles.DisplayedArticle(title: $0.headline.main, abstract: $0.abstract) })
        let viewModel = Landing.SearchArticle.ViewModel(content: content)
        viewController.displaySearchActicle(viewModel: viewModel)
    }

    func presentSelectDetail(response: Landing.SelectDetail.Response) {
        let viewModel = Landing.SelectDetail.ViewModel()
        viewController.displaySelectDetail(viewModel: viewModel)
    }
}
