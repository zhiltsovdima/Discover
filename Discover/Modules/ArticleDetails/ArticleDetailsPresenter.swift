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
    func linkTapped()
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
        view?.updateUI(with: article)
        view?.updateFavoriteButton(isFavorite: article.isFavorite)
    }
    
    func favoriteButtonTapped() {
        interactor.favoriteButtonTapped(article: article)
        view?.updateFavoriteButton(isFavorite: article.isFavorite)
    }
    
    func backButtonTapped() {
        router.backToRoot()
    }
    
    func linkTapped() {
        guard let link = article.link else { return }
        interactor.linkTapped(link: link)
    }
}
