//
//  LandingViewController.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

import UIKit
import Alamofire

protocol LandingViewControllerInterface: AnyObject {
    func displayMostViewedArticles(viewModel: Landing.GetMostViewedArticles.ViewModel)
    func displayFilterSection(viewModel: Landing.FilterSection.ViewModel)
    func displaySearchActicle(viewModel: Landing.SearchArticle.ViewModel)
    func displaySelectDetail(viewModel: Landing.SelectDetail.ViewModel)
}

class LandingViewController: UIViewController, LandingViewControllerInterface {
    var router: LandingRouter!
    var interactor: LandingInteractorInterface!

    private let refreshControl = UIRefreshControl()
    @IBOutlet private weak var periodButton: UIButton!
    @IBOutlet private weak var sectionButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    private var displayedArticles: [Landing.GetMostViewedArticles.DisplayedArticle] = []
    private var sections: [String] = []
    private var period: Landing.GetMostViewedArticles.Request.Period = .oneDay {
        didSet {
            var title = period.rawValue + " day"
            if period != .oneDay {
                title += "s"
            }
            periodButton.setTitle(title, for: .normal)
        }
    }
    private var searchText: String?

    override func awakeFromNib() {
      super.awakeFromNib()
      configure(viewController: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: NewsTableViewCell.nibName,
                                 bundle: Bundle.main),
                           forCellReuseIdentifier: NewsTableViewCell.identifier)
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        getMostViewedArticles(.oneDay)
    }

    private func getMostViewedArticles(_ period: Landing.GetMostViewedArticles.Request.Period) {
        self.period = period
        setFilterSection(nil)
        refreshControl.beginRefreshing()
        let request = Landing.GetMostViewedArticles.Request(period: period)
        interactor.getMostViewedArticles(request: request)
    }

    private func searchArticles(_ searchString: String, force: Bool = false) {
        if (searchText ?? "").lowercased() == searchString.lowercased() && !force {
            return
        }
        searchText = searchString
        displayedArticles = []
        tableView.reloadData()
        refreshControl.beginRefreshing()
        let request = Landing.SearchArticle.Request(searchString: searchString)
        interactor.searchActicle(request: request)
    }

    private func setFilterSection(_ section: String?) {
        searchText = nil
        displayedArticles = []
        tableView.reloadData()
        let request = Landing.FilterSection.Request(section: section)
        interactor.setFilterSection(request: request)
    }
    
    func displayMostViewedArticles(viewModel: Landing.GetMostViewedArticles.ViewModel) {
        refreshControl.endRefreshing()
        displayedArticles = viewModel.content
        sections = viewModel.sections
        tableView.reloadData()
    }

    func displayFilterSection(viewModel: Landing.FilterSection.ViewModel) {
        sectionButton.setTitle(viewModel.section, for: .normal)
        displayedArticles = viewModel.content
        tableView.reloadData()
    }

    func displaySearchActicle(viewModel: Landing.SearchArticle.ViewModel) {
        refreshControl.endRefreshing()
        displayedArticles = viewModel.content
        tableView.reloadData()
    }

    func displaySelectDetail(viewModel: Landing.SelectDetail.ViewModel) {
        router.navigateToDetail()
    }

    @objc func refreshAction(_ sender: UIRefreshControl) {
        if let searchText = searchText {
            searchArticles(searchText, force: true)
        } else {
            getMostViewedArticles(period)
        }
    }

    // Debouncer when typing search
    @IBAction func valueChanged(_ sender: UITextField) {
        Debounce<String>.input(sender.text ?? "", comparedAgainst: sender.text ?? "") { [weak self] in
            self?.periodButton.isHidden = !(sender.text ?? "").isEmpty
            self?.sectionButton.isHidden = !(sender.text ?? "").isEmpty
            if $0.isEmpty {
                self?.setFilterSection(nil)
            } else {
                self?.searchArticles($0)
            }
        }
    }

    // Send period to API
    @IBAction func selectPeriod() {
        let alertController = UIAlertController(title: "Select Period",
                                                message: nil, preferredStyle: .actionSheet)
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

    // Filter list by section
    @IBAction func selectSection() {
        let alertController = UIAlertController(title: "Select Section",
                                                message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "All", style: .default) { [weak self] _ in
            self?.setFilterSection(nil)
        })
        sections.forEach { section in
            alertController.addAction(UIAlertAction(title: section, style: .default) { [weak self] _ in
                self?.setFilterSection(section)
            })
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }

}

extension LandingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedArticles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        cell.textLabel?.text = displayedArticles[indexPath.row].title
        cell.detailTextLabel?.text = displayedArticles[indexPath.row].abstract
        return cell
    }
}

extension LandingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = Landing.SelectDetail.Request(index: indexPath.row)
        interactor.setSelectDetail(request: request)
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
