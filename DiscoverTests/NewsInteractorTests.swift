//
//  NewsInteractorTests.swift
//  DiscoverTests
//
//  Created by Dima Zhiltsov on 13.07.2023.
//

import XCTest
@testable import Discover

final class NewsInteractorTests: XCTestCase {
    
    var sut: NewsInteractor!
    var newsService: NewsServiceMock!
    var presenter: NewsPresenterMock!

    override func setUpWithError() throws {
        newsService = NewsServiceMock()
        presenter = NewsPresenterMock()
        sut = NewsInteractor(newsService: newsService)
        sut.presenter = presenter
    }

    override func tearDownWithError() throws {
        newsService = nil
        sut = nil
    }
}

extension NewsInteractorTests {
    
    func testSynchronizeWithLocalData() throws {
        // Given
        
        let article1 = Article(title: "title1", description: "description1", content: "content1", category: "category1", link: nil, creator: nil, date: nil, imageUrl: nil)
        let article2 = Article(title: "title2", description: "description2", content: "content2", category: "category2", link: nil, creator: nil, date: nil, imageUrl: nil)
        
        let favorite1 = Article(title: "title1", description: "description1", content: "content1", category: "category1", link: nil, creator: nil, date: nil, imageUrl: nil)
        let favorite2 = Article(title: "title2", description: "description2", content: "content2", category: "category2", link: nil, creator: nil, date: nil, imageUrl: nil)
        favorite1.isFavorite = true
        favorite2.isFavorite = true
        favorite1.id = "foo"
        favorite2.id = "id"
        newsService.favoritesNews = [favorite1, favorite2]
        
        let articles = [article1, article2]
        XCTAssertFalse(article1.isFavorite)
        XCTAssertFalse(article2.isFavorite)
        XCTAssertTrue(favorite1.isFavorite)
        XCTAssertTrue(favorite2.isFavorite)
        XCTAssertEqual(article1, favorite1)
        XCTAssertEqual(article2, favorite2)
        
        // When
        sut.synchronizeWithLocalData(articles: articles)
        
        // Then
        XCTAssertTrue(newsService.isGetFavoritesNewsCalled)
        
        XCTAssertTrue(article1.isFavorite)
        XCTAssertTrue(article2.isFavorite)
        
        XCTAssertEqual(article1.id, favorite1.id)
        XCTAssertEqual(article2.id, favorite2.id)
        
        XCTAssertEqual(article1, favorite1)
        XCTAssertEqual(article2, favorite2)
    }
    
    
    func testloadNews() {
        let isMoreLoad = false
        
        let newsData = GetJSONMock.createNewsDataFromJson()
        let successResult: Result<NewsData, Error> = Result.success(newsData)
        newsService.expectedLoadNewsCompletionResult = successResult
        let expectation = XCTestExpectation(description: "Fetch news data")

        // When
        sut.loadNews(isMoreLoad: isMoreLoad)
        
        // Then
        XCTAssertTrue(newsService.isLoadNewsCalled)
        XCTAssertNil(newsService.loadNewsNextPage)
        
        XCTAssertTrue(presenter.isConfigureNewsCalled)
        XCTAssertEqual(presenter.configureNewsArticles, newsData.results)
        XCTAssertEqual(presenter.configureNewsIsMoreLoad, isMoreLoad)
    }

}
