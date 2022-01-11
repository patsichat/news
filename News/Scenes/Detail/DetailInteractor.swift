//
//  DetailInteractor.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/11/22.
//

protocol DetailInteractorInterface {
    func getWebView(request: Detail.GetWebView.Request)
    var urlString: String? { get set }
}

class DetailInteractor: DetailInteractorInterface {
    var presenter: DetailPresenterInterface!
    var urlString: String?
    func getWebView(request: Detail.GetWebView.Request) {
        guard let urlString = urlString else { return }
        let response = Detail.GetWebView.Response(urlString: urlString)
        presenter.presentWebView(response: response)
    }
}
