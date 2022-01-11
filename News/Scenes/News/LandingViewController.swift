//
//  LandingViewController.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

import UIKit

protocol LandingViewControllerInterface: AnyObject {
    func displayMostViewedArticles(viewModel: Landing.GetMostViewedArticles.ViewModel)
}

class LandingViewController: UIViewController, LandingViewControllerInterface {
    var router: LandingRouter!
    var interactor: LandingInteractorInterface!

    private let refreshControl = UIRefreshControl()
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var periodButton: UIButton!
    private var mostViewedArticles: [Landing.GetMostViewedArticles.DisplayedArticle] = []
    private var period: Landing.GetMostViewedArticles.Request.Period = .oneDay {
        didSet {
            var title = period.rawValue + " day"
            if period != .oneDay {
                title += "s"
            }
            periodButton.setTitle(title, for: .normal)
        }
    }

    override func awakeFromNib() {
      super.awakeFromNib()
      configure(viewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: NewsTableViewCell.identifier)
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        getMostViewedArticles(.oneDay)
    }

    private func getMostViewedArticles(_ period: Landing.GetMostViewedArticles.Request.Period) {
        self.period = period
        mostViewedArticles = []
        tableView.reloadData()
        refreshControl.beginRefreshing()
        let request = Landing.GetMostViewedArticles.Request(period: period)
        interactor.getMostViewedArticles(request: request)
    }
    
    func displayMostViewedArticles(viewModel: Landing.GetMostViewedArticles.ViewModel) {
        refreshControl.endRefreshing()
        mostViewedArticles = viewModel.content
        tableView.reloadData()
    }

    @objc func refreshAction(_ sender: UIRefreshControl) {
        getMostViewedArticles(period)
    }

    @IBAction func selectPeriod() {
        let alertController = UIAlertController(title: "Select Period", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "1 day", style: .default) { [weak self] _ in
            self?.getMostViewedArticles(.oneDay)
        })
        alertController.addAction(UIAlertAction(title: "7 days", style: .default) { [weak self] _ in
            self?.getMostViewedArticles(.sevenDays)
        })
        alertController.addAction(UIAlertAction(title: "30 days", style: .default) { [weak self] _ in
            self?.getMostViewedArticles(.thirtyDays)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }

}

extension LandingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mostViewedArticles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = mostViewedArticles[indexPath.row].title
        cell.detailTextLabel?.text = mostViewedArticles[indexPath.row].abstract
        return cell
    }
}

extension LandingViewController {
  func configure(viewController: LandingViewController) {
    let router = LandingRouter()
    router.viewController = viewController

    let presenter = LandingPresenter()
    presenter.viewController = viewController

    let interactor = LandingInteractor()
    interactor.worker = NewsWorker(store: NewsRestStore())
    interactor.presenter = presenter

    viewController.interactor = interactor
    viewController.router = router
  }
}
