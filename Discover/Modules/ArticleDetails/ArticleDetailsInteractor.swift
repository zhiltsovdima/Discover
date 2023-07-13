//
//  ArticleDetailInteractor.swift
//  Discover
//
//  Created by Dima Zhiltsov on 12.07.2023.
//

import UIKit

protocol ArticleDetailsInteractorProtocol: AnyObject {
    func favoriteButtonTapped(article: Article)
    func linkTapped(link: String)
}

final class ArticleDetailsInteractor{
    weak var presenter: ArticleDetailsPresenterProtocol!
    
    private let newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
    }
}

// MARK: - ArticleDetailsInteractorProtocol

extension ArticleDetailsInteractor: ArticleDetailsInteractorProtocol {
    
    func favoriteButtonTapped(article: Article) {
        article.isFavorite ? newsService.removeArticleFromFavorites(article: article) : newsService.saveArticleToFavorites(article: article)
    }
    
    func linkTapped(link: String) {
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }
}
