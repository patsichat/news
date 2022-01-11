//
//  NewsPresenterTests.swift
//  NewsTests
//
//  Created by Patsicha Tongteeka on 1/12/22.
//

@testable import News
import XCTest

final class LandingPresenterTests: XCTestCase {

  // MARK: - Subject under test

  private var presenter: LandingPresenter!
  private var viewControllerSpy: LandingViewControllerSpy!

  // MARK: - Test lifecycle

  override func setUp() {
    super.setUp()
    setupPaymentMethodPresenter()
  }

  override func tearDown() {
    super.tearDown()
  }

  // MARK: - Test setup

  private func setupPaymentMethodPresenter() {
    presenter = LandingPresenter()
    viewControllerSpy = LandingViewControllerSpy()
    presenter.viewController = viewControllerSpy
  }

  // MARK: - Test doubles

    private final class LandingViewControllerSpy: LandingViewControllerInterface {
        var displayMostViewedArticlesCalled = false
        var displayFilterSectionCalled = false
        var displaySearchActicleCalled = false
        var displaySelectDetailCalled = false
        var displayMostViewedArticlesViewModel: Landing.GetMostViewedArticles.ViewModel?
        var displayFilterSectionViewModel: Landing.FilterSection.ViewModel?
        var displaySearchActicleViewModel: Landing.SearchArticle.ViewModel?
        func displayMostViewedArticles(viewModel: Landing.GetMostViewedArticles.ViewModel) {
            displayMostViewedArticlesCalled = true
            displayMostViewedArticlesViewModel = viewModel
        }

        func displayFilterSection(viewModel: Landing.FilterSection.ViewModel) {
            displayFilterSectionCalled = true
            displayFilterSectionViewModel = viewModel
        }

        func displaySearchActicle(viewModel: Landing.SearchArticle.ViewModel) {
            displaySearchActicleCalled = true
            displaySearchActicleViewModel = viewModel
        }

        func displaySelectDetail(viewModel: Landing.SelectDetail.ViewModel) {
            displaySelectDetailCalled = true
        }


  }

  // MARK: - Tests

    func testPresentMostViewedArticlesShouldAskViewControllerToDisplayMostViewedArticles() {
        // Given
        let response = Landing.GetMostViewedArticles.Response(result: [MostViewedArticlesResponse.Article(title: "title",
                                                                                                           abstract: "abstract",
                                                                                                           section: "section",
                                                                                                           url: "url")])
        // When
        presenter.presentMostViewedArticles(response: response)
        // Then
        XCTAssert(viewControllerSpy.displayMostViewedArticlesCalled, "presentMostViewedArticles() should ask view controller to displayMostViewedArticles()")
        XCTAssertEqual(viewControllerSpy.displayMostViewedArticlesViewModel?.content.count, 1)
        XCTAssertEqual(viewControllerSpy.displayMostViewedArticlesViewModel?.content.first?.title, "title")
        XCTAssertEqual(viewControllerSpy.displayMostViewedArticlesViewModel?.content.first?.abstract, "abstract")
        XCTAssertEqual(viewControllerSpy.displayMostViewedArticlesViewModel?.sections.count, 1)
        XCTAssertEqual(viewControllerSpy.displayMostViewedArticlesViewModel?.sections.first, "section")
    }

    func testPresentFilterSectionShouldAskViewControllerToDisplayFilterSection() {
        // Given
        let response = Landing.FilterSection.Response(section: "section",
                                                      result: [MostViewedArticlesResponse.Article(title: "title",
                                                                                                  abstract: "abstract",
                                                                                                  section: "section",
                                                                                                  url: "url")])
        // When
        presenter.presentFilterSection(response: response)
        // Then
        XCTAssert(viewControllerSpy.displayFilterSectionCalled, "presentFilterSection() should ask view controller to displayFilterSection()")
        XCTAssertEqual(viewControllerSpy.displayFilterSectionViewModel?.content.count, 1)
        XCTAssertEqual(viewControllerSpy.displayFilterSectionViewModel?.content.first?.title, "title")
        XCTAssertEqual(viewControllerSpy.displayFilterSectionViewModel?.content.first?.abstract, "abstract")
        XCTAssertEqual(viewControllerSpy.displayFilterSectionViewModel?.section, "section")
    }

    func testPresentSearchActicleShouldAskViewControllerToDisplaySearchActicle() {
        // Given
        let response = Landing.SearchArticle.Response(result: [SearchArticlesResponse.Article(headline: .init(main: "headline"),
                                                                                              abstract: "abstract", url: "url")])
        // When
        presenter.presentSearchActicle(response: response)
        // Then
        XCTAssert(viewControllerSpy.displaySearchActicleCalled, "presentSearchActicle() should ask view controller to displaySearchActicle()")
        XCTAssertEqual(viewControllerSpy.displaySearchActicleViewModel?.content.count, 1)
        XCTAssertEqual(viewControllerSpy.displaySearchActicleViewModel?.content.first?.title, "headline")
        XCTAssertEqual(viewControllerSpy.displaySearchActicleViewModel?.content.first?.abstract, "abstract")
    }

    func testPresentSelectDetailShouldAskViewControllerToDisplaySelectDetail() {
        // Given
        let response = Landing.SelectDetail.Response()
        // When
        presenter.presentSelectDetail(response: response)
        // Then
        XCTAssert(viewControllerSpy.displaySelectDetailCalled, "presentSelectDetail() should ask view controller to displaySelectDetail()")
    }
}
