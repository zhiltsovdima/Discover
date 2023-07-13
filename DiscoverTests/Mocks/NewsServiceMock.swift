//
//  NewsServiceMock.swift
//  DiscoverTests
//
//  Created by Dima Zhiltsov on 13.07.2023.
//

import UIKit
@testable import Discover

final class NewsServiceMock: NewsServiceProtocol {
    
    var isLoadNewsCalled = false
    var loadNewsNextPage: String?
    var expectedLoadNewsCompletionResult: (Result<NewsData, Error>)?
    
    var loadImageCalled = false
    var expectedLoadImageCompletion: (Result<UIImage, Error>)?
    
    var isGetFavoritesNewsCalled = false
    var isSaveArticleToFavoritesCalled = false
    var isRemoveArticleFromFavoritesCalled = false
    
    var favoritesNews: [Article] = []
    
    func loadNews(nextPage: String?, completion: @escaping (Result<NewsData, Error>) -> Void) {
        isLoadNewsCalled = true
        loadNewsNextPage = nextPage
        guard let expectedLoadNewsCompletionResult else { return }
        completion(expectedLoadNewsCompletionResult)
    }
    
    func loadImage(for article: Article, completion: @escaping (Result<UIImage, Error>) -> Void) {
        loadImageCalled = true
        guard let expectedLoadImageCompletion else { return }
        completion(expectedLoadImageCompletion)
    }
    
    func getFavoritesNews() -> [Article] {
        isGetFavoritesNewsCalled = true
        return favoritesNews
    }
    
    func saveArticleToFavorites(article: Article) {
        isSaveArticleToFavoritesCalled = true
        favoritesNews.append(article)
    }
    
    func removeArticleFromFavorites(article: Article) {
        isRemoveArticleFromFavoritesCalled = true
        if let index = favoritesNews.firstIndex(where: { $0.id == article.id }) {
            favoritesNews.remove(at: index)
        }
    }
}

