//
//  NewsServiceTests.swift
//  DiscoverTests
//
//  Created by Dima Zhiltsov on 13.07.2023.
//

import XCTest
@testable import Discover

final class NewsServiceTests: XCTestCase {

    var sut: NewsServiceProtocol!
    var networkManager: NetworkManagerMock!
    var coreDataManager: CoreDataManagerMock!
    
    override func setUpWithError() throws {
        networkManager = NetworkManagerMock()
        coreDataManager = CoreDataManagerMock()
        sut = NewsService(networkManager, coreDataManager)
    }
    
    override func tearDownWithError() throws {
        networkManager = nil
        coreDataManager = nil
        sut = nil
    }
}

// MARK: - LoadNews Tests

extension NewsServiceTests {
    
    func testLoadNews_Successful() throws {
        // Given
        
        let expectedResult = GetJSONMock.createNewsDataFromJson()
        let expectedData = GetJSONMock.getDataFromJsonFile()
        
        networkManager.expectedResult = .success(expectedData)
        let expectation = XCTestExpectation(description: "Fetch news data")
        
        // When
        sut.loadNews(nextPage: nil) { result in
            // Then
            switch result {
            case .success(let newsData):
                XCTAssertEqual(newsData, expectedResult, "Returned news data should match the expected result")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadNews_Failure() throws {
        // Given
        let expectedError = NetworkError.failed
        networkManager.expectedResult = .failure(expectedError)
        let expectation = XCTestExpectation(description: "Get an error")

        // When
        sut.loadNews(nextPage: nil) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let netError as NetworkError):
                XCTAssertEqual(netError, expectedError, "Incorrect error")
                expectation.fulfill()
            case .failure(_):
                XCTFail("Should be NetworkError")
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - LoadImage Tests

extension NewsServiceTests {
    
    func testloadImage_Successful() throws {
        // Given
        let urlString = "http://mock.com/image.jpg"
        let article = Article(title: "", description: "", content: "", category: "", link: "", creator: "", date: nil, imageUrl: urlString)
        let expectedImage = R.Images.defaultImage
        guard let expectedImageData = expectedImage.jpegData(compressionQuality: 1.0) else { return }
        
        networkManager.expectedResult = .success(expectedImageData)
        let expectation = XCTestExpectation(description: "Fetch an image")
        
        // When
        sut.loadImage(for: article) { result in
            // Then
            switch result {
            case .success(let image):
                guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                    XCTFail("Failed to create image from data")
                    return
                }
                XCTAssertEqual(imageData.count, expectedImageData.count, accuracy: 100, "Incorrect image")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not fail")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadImage_Failure() throws {
        // Given
        let urlString = "invalid-url"
        let article = Article(title: "", description: "", content: "", category: "", link: "", creator: "", date: nil, imageUrl: urlString)
        let expectedError = NetworkError.failed
        networkManager.expectedResult = .failure(expectedError)
        let expectation = XCTestExpectation(description: "Get an error")
        
        // When
        sut.loadImage(for: article) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let netError as NetworkError):
                XCTAssertEqual(netError, expectedError, "Incorrect error")
                expectation.fulfill()
            case .failure(_):
                XCTFail("Should be Network Error")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - GetFavoritesNews Tests

extension NewsServiceTests {
    
    func testGetFavoritesNews_Success() throws {
        let article1 = Article(title: "title1", description: "description1", content: "content1", category: "category1", link: nil, creator: nil, date: nil, imageUrl: nil)
        let article2 = Article(title: "title2", description: "description2", content: "content2", category: "category2", link: nil, creator: nil, date: nil, imageUrl: nil)
        
        let expectedResult = [article1, article2]
        
        let item1 = CoreDataArticle(context: coreDataManager.moc)
        item1.setValue(article1.title, forKey: "title")
        item1.setValue(article1.description, forKey: "descriptionArticle")
        item1.setValue(article1.content, forKey: "content")
        item1.setValue(article1.category, forKey: "category")
        
        let item2 = CoreDataArticle(context: coreDataManager.moc)
        item2.setValue(article2.title, forKey: "title")
        item2.setValue(article2.description, forKey: "descriptionArticle")
        item2.setValue(article2.content, forKey: "content")
        item2.setValue(article2.category, forKey: "category")
        
        let storedArticles = [item1, item2]
        
        coreDataManager.storedItems = storedArticles
        
        let result = sut.getFavoritesNews()
        XCTAssertEqual(result, expectedResult)
    }
    
    func testGetFavoritesNews_Failure() throws {
        let article1 = Article(title: "title1", description: "description1", content: "content1", category: "category1", link: nil, creator: nil, date: nil, imageUrl: nil)
        let article2 = Article(title: "title2", description: "description2", content: "content2", category: "category2", link: nil, creator: nil, date: nil, imageUrl: nil)
        
        let expectedResult = [article1, article2]
        
        let item1 = CoreDataArticle(context: coreDataManager.moc)
        item1.setValue(article1.title, forKey: "title")
        item1.setValue(article1.description, forKey: "descriptionArticle")
        item1.setValue(article1.content, forKey: "content")
        item1.setValue(article1.category, forKey: "category")
        
        let item2 = CoreDataArticle(context: coreDataManager.moc)
        item2.setValue(article1.title, forKey: "title")
        item2.setValue(article2.description, forKey: "descriptionArticle")
        item2.setValue(article1.content, forKey: "content")
        item2.setValue(article2.category, forKey: "category")
        
        let storedArticles = [item1, item2]
        
        coreDataManager.storedItems = storedArticles
        
        let result = sut.getFavoritesNews()
        XCTAssertNotEqual(result, expectedResult)
    }
}

// MARK: - SaveArticleToFavorites Tests

extension NewsServiceTests {
    
    func testSaveArticleToFavorites_Success() throws {
        let article1 = Article(title: "title1", description: "description1", content: "content1", category: "category1", link: nil, creator: nil, date: nil, imageUrl: nil)
        
        XCTAssertNil(article1.id)

        sut.saveArticleToFavorites(article: article1)
    
        XCTAssertTrue(coreDataManager.isSaveCalled)
        XCTAssertTrue(article1.isFavorite)
        XCTAssertNotNil(article1.id)
    }
}

// MARK: - RemoveArticleFromFavorites Tests

extension NewsServiceTests {
    
    func testRemoveArticleFromFavorites_Success() throws {
        let article1 = Article(title: "title1", description: "description1", content: "content1", category: "category1", link: nil, creator: nil, date: nil, imageUrl: nil)
        article1.id = "foo"
        article1.isFavorite = true
        
        XCTAssertNotNil(article1.id)
        XCTAssertTrue(article1.isFavorite)

        sut.removeArticleFromFavorites(article: article1)
    
        XCTAssertTrue(coreDataManager.isDeleteObjectCalled)
        XCTAssertFalse(article1.isFavorite)
    }
}
