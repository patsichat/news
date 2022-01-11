//
//  LandingPresenter.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

protocol LandingPresenterInterface {
    func presentMostViewedArticles(response: Landing.GetMostViewedArticles.Response)
}

class LandingPresenter: LandingPresenterInterface {
    weak var viewController: LandingViewControllerInterface!
    func presentMostViewedArticles(response: Landing.GetMostViewedArticles.Response) {

        let content = response.result.map({ Landing.GetMostViewedArticles.DisplayedArticle(title: $0.title, abstract: $0.abstract) })
        let viewModel = Landing.GetMostViewedArticles.ViewModel(content: content)
        viewController.displayMostViewedArticles(viewModel: viewModel)
    }
}
