//
//  NewsPresenter.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

protocol NewsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func configureItems(with fetchedNews: [ArticleData])
    
    func numberOfItems() -> Int
    func configure(cell: ArticleCellProtocol, at indexPath: IndexPath)
}

final class NewsPresenter {
    weak var view: NewsViewProtocol?
    var interactor: NewsInteractorProtocol!
    
    private let router: NewsRouterProtocol
    
    private var news = [Article]()
    
    init(router: NewsRouterProtocol) {
        self.router = router
    }
    
}

extension NewsPresenter: NewsPresenterProtocol {
    func viewDidLoad() {
        interactor.fetchNews()
    }
    
    func configureItems(with fetchedNews: [ArticleData]) {
        news = fetchedNews.map {
            Article(
                title: $0.title ?? "",
                description: $0.description ?? "",
                date: $0.pubDate ?? ""
            )
        }
        view?.updateUI()
    }
    
    func numberOfItems() -> Int {
        return news.count
    }
    
    func configure(cell: ArticleCellProtocol, at indexPath: IndexPath) {
        let article = news[indexPath.row]
        cell.setup(with: article)
    }
}
