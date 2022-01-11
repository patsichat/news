//
//  DetailPresenter.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/11/22.
//

protocol DetailPresenterInterface {
    func presentWebView(response: Detail.GetWebView.Response)
}

class DetailPresenter: DetailPresenterInterface {
    weak var viewController: DetailViewControllerInterface!
    func presentWebView(response: Detail.GetWebView.Response) {
        let urlString = response.urlString
        let viewModel = Detail.GetWebView.ViewModel(urlString: urlString)
        viewController.displayWebView(viewModel: viewModel)
    }
}
