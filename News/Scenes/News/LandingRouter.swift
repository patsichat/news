//
//  LandingRouter.swift
//  News
//
//  Created by Patsicha Tongteeka on 1/10/22.
//

import UIKit

protocol LandingRouterInterface {
    func navigateToDetail()
}

class LandingRouter: LandingRouterInterface {
    weak var viewController: LandingViewController!
    func navigateToDetail() {
        guard let detailViewController = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as? DetailViewController else { return }
        detailViewController.interactor.urlString = viewController.interactor.urlString
        viewController.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
