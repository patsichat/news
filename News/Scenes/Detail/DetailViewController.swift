//
//  DetailViewController.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/11/22.
//

import UIKit
import WebKit

protocol DetailViewControllerInterface: AnyObject {
    func displayWebView(viewModel: Detail.GetWebView.ViewModel)
}

class DetailViewController: UIViewController, DetailViewControllerInterface {

    var interactor: DetailInteractorInterface!
    var webView: WKWebView!

    override func awakeFromNib() {
      super.awakeFromNib()
      configure(viewController: self)
    }

    override func loadView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false

        // Create a configuration for the preferences
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        webView = WKWebView(frame: .zero, configuration: configuration)
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getWebView()
    }

    private func getWebView() {
        let request = Detail.GetWebView.Request()
        interactor.getWebView(request: request)
    }
    
    func displayWebView(viewModel: Detail.GetWebView.ViewModel) {
        guard let url = URL(string: viewModel.urlString) else { return }
        webView.load(URLRequest(url: url))
    }

}

extension DetailViewController {
  func configure(viewController: DetailViewController) {
    let presenter = DetailPresenter()
    presenter.viewController = viewController

    let interactor = DetailInteractor()
    interactor.presenter = presenter

    viewController.interactor = interactor
  }
}
