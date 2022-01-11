//
//  NewsInteractorTests.swift
//  NewsTests
//
//  Created by Patsicha Tongteeka on 1/12/22.
//

@testable import News
import XCTest

final class LandingInteractorTests: XCTestCase {

    // MARK: - Subject under test

    private var interactor: LandingInteractor!
    private var presenterSpy: LandingPresenterSpy!
    private var workerSpy: NewsWorkerSpy!

    // MARK: - Test lifecycle

    override func setUp() {
        super.setUp()
        setupLandingInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test setup

    private func setupLandingInteractor() {
        interactor = LandingInteractor()
        presenterSpy = LandingPresenterSpy()
        interactor.presenter = presenterSpy
        workerSpy = NewsWorkerSpy(store: NewsRestStore())
        interactor.worker = workerSpy
    }

    // MARK: - Test doubles

    private final class LandingPresenterSpy: LandingPresenterInterface {
        var presentMostViewedArticlesCalled = false
        var presentFilterSectionCalled = false
        var presentSearchActicleCalled = false
        var presentSelectDetailCalled = false
        var presentMostViewedArticlesResponse: Landing.GetMostViewedArticles.Response?
        var presentFilterSectionResponse: Landing.FilterSection.Response?
        var presentSearchActicleResponse: Landing.SearchArticle.Response?
        var presentSelectDetailResponse: Landing.SelectDetail.Response?

        func presentMostViewedArticles(response: Landing.GetMostViewedArticles.Response) {
            presentMostViewedArticlesCalled = true
            presentMostViewedArticlesResponse = response
        }

        func presentFilterSection(response: Landing.FilterSection.Response) {
            presentFilterSectionCalled = true
            presentFilterSectionResponse = response
        }

        func presentSearchActicle(response: Landing.SearchArticle.Response) {
            presentSearchActicleCalled = true
            presentSearchActicleResponse = response
        }

        func presentSelectDetail(response: Landing.SelectDetail.Response) {
            presentSelectDetailCalled = true
            presentSelectDetailResponse = response
        }
    }

    private final class NewsWorkerSpy: NewsWorker {
      var forceFailure: Bool = false
        override func getMostViewedArticles(period: Landing.GetMostViewedArticles.Request.Period, completion: @escaping (Result<[MostViewedArticlesResponse.Article]>) -> Void) {
            completion(Result.success(result: [MostViewedArticlesResponse.Article(title: "title",
                                                                                  abstract: "abstract",
                                                                                  section: "section",
                                                                                  url: "url")]))
        }

        override func searchActicles(_ searchString: String, _ completion: @escaping (Result<[SearchArticlesResponse.Article]>) -> Void) {
            completion(Result.success(result: [SearchArticlesResponse.Article(headline: .init(main: "headline"),
                                                                              abstract: "abstract",
                                                                              url: "url"),
                                               SearchArticlesResponse.Article(headline: .init(main: "headline2"),
                                                                              abstract: "abstract2",
                                                                              url: "url2")]))
        }
    }

    // MARK: - Tests

    func testGetMostViewedArticlesShouldAskPresenterToPresentMostViewedArticles() {
        // Given
        let request = Landing.GetMostViewedArticles.Request(period: .oneDay)

        // When
        interactor.getMostViewedArticles(request: request)

        // Then
        XCTAssert(presenterSpy.presentMostViewedArticlesCalled, "getMostViewedArticles() should ask presenter to presentMostViewedArticles()")
        XCTAssertEqual(presenterSpy.presentMostViewedArticlesResponse?.result.count, 1)
        XCTAssertEqual(presenterSpy.presentMostViewedArticlesResponse?.result.first?.title, "title")
        XCTAssertEqual(presenterSpy.presentMostViewedArticlesResponse?.result.first?.abstract, "abstract")
        XCTAssertEqual(presenterSpy.presentMostViewedArticlesResponse?.result.first?.section, "section")
        XCTAssertEqual(presenterSpy.presentMostViewedArticlesResponse?.result.first?.url, "url")
    }

    func testSetFilterSectionWithEmptyResultShouldAskPresenterToPresentMostViewedArticles() {
        // Given
        let request = Landing.FilterSection.Request(section: "health")

        // When
        interactor.setFilterSection(request: request)

        // Then
        XCTAssert(presenterSpy.presentFilterSectionCalled, "setFilterSection() should ask presenter to presentFilterSection()")
        XCTAssertEqual(presenterSpy.presentFilterSectionResponse?.result.count, 0)
        XCTAssertEqual(presenterSpy.presentFilterSectionResponse?.section, "health")
    }

    func testSetFilterSectionShouldAskPresenterToPresentMostViewedArticles() {
        // Given
        interactor.getMostViewedArticles(request: .init(period: .oneDay))
        let request = Landing.FilterSection.Request(section: "section")

        // When
        interactor.setFilterSection(request: request)

        // Then
        XCTAssert(presenterSpy.presentFilterSectionCalled, "setFilterSection() should ask presenter to presentFilterSection()")
        XCTAssertEqual(presenterSpy.presentFilterSectionResponse?.result.count, 1)
        XCTAssertEqual(presenterSpy.presentFilterSectionResponse?.section, "section")
    }

    func testSearchActicleShouldAskPresenterToPresentSearchActicle() {
        // Given
        let request = Landing.SearchArticle.Request(searchString: "abc")

        // When
        interactor.searchActicle(request: request)

        // Then
        XCTAssert(presenterSpy.presentSearchActicleCalled, "searchActicle() should ask presenter to presentSearchActicle()")
        XCTAssertEqual(presenterSpy.presentSearchActicleResponse?.result.count, 2)
        XCTAssertEqual(presenterSpy.presentSearchActicleResponse?.result[0].headline.main, "headline")
        XCTAssertEqual(presenterSpy.presentSearchActicleResponse?.result[0].abstract, "abstract")
        XCTAssertEqual(presenterSpy.presentSearchActicleResponse?.result[0].url, "url")
        XCTAssertEqual(presenterSpy.presentSearchActicleResponse?.result[1].headline.main, "headline2")
        XCTAssertEqual(presenterSpy.presentSearchActicleResponse?.result[1].abstract, "abstract2")
        XCTAssertEqual(presenterSpy.presentSearchActicleResponse?.result[1].url, "url2")
    }

    func testSetSelectDetailShouldAskPresentSelectDetail() {
        // Given
        interactor.getMostViewedArticles(request: .init(period: .oneDay))
        let request = Landing.SelectDetail.Request(index: 0)

        // When
        interactor.setSelectDetail(request: request)

        // Then
        XCTAssert(presenterSpy.presentSelectDetailCalled, "setSelectDetail() should ask presenter to presentSelectDetail()")
    }

}
