//
//  ArticleDetailPresenter.swift
//  Discover
//
//  Created by Dima Zhiltsov on 12.07.2023.
//

import Foundation

protocol ArticleDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func favoriteButtonTapped()
    func backButtonTapped()
}

final class ArticleDetailsPresenter {
    weak var view: ArticleDetailsViewProtocol?
    var interactor: ArticleDetailsInteractorProtocol!
    
    private let router: NewsRouterProtocol
    
    private let article: Article
    
    init(router: NewsRouterProtocol, article: Article) {
        self.router = router
        self.article = article
    }
}

// MARK: - ArticleDetailsPresenterProtocol

extension ArticleDetailsPresenter: ArticleDetailsPresenterProtocol {
    
    func viewDidLoad() {
        view?.updateUI(
            title: article.title,
            category: article.category,
            description: article.description,
            content: article.content,
            image: article.image ?? R.Images.defaultImage,
            timeAgo: article.timeAgo
        )
    }
    
    func favoriteButtonTapped() {
        view?.updateFavoriteButton(isFavorite: Bool.random())
    }
    
    func backButtonTapped() {
        router.backToRoot()
    }
}
