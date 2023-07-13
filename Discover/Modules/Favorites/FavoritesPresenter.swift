//
//  FavoritesPresenter.swift
//  Discover
//
//  Created by Dima Zhiltsov on 12.07.2023.
//

import Foundation

protocol FavoritesPresenterProtocol: AnyObject {
    func updateNews()
    
    func updateUI(with news: [Article])
    
    func numberOfItems() -> Int
    func configure(cell: ArticleCellProtocol, at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
}

final class FavoritesPresenter {
    weak var view: FavoritesViewProtocol?
    var interactor: FavoritesInteractorProtocol!
    
    private let router: NewsRouterProtocol
    
    private var news = [Article]()
    
    init(router: NewsRouterProtocol) {
        self.router = router
    }
}

// MARK: - FavoritesPresenterProtocol

extension FavoritesPresenter: FavoritesPresenterProtocol {
    
    func updateNews() {
        interactor.loadFavoriteNews()
    }
    
    // UI Updating
    
    func updateUI(with news: [Article]) {
        self.news = news
        DispatchQueue.main.async { [weak self] in
            guard let self else {return }
            view?.updateUI()
        }
    }    
        
    // Table Configuration
    
    func numberOfItems() -> Int {
        return news.count
    }
    
    func configure(cell: ArticleCellProtocol, at indexPath: IndexPath) {
        let article = news[indexPath.row]
        cell.setup(with: article)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        let article = news[indexPath.row]
        router.showArticleDetails(article: article)
    }
}
