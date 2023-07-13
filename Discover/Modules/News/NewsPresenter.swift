//
//  NewsPresenter.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

protocol NewsPresenterProtocol: AnyObject {
    func updateNews(isMoreLoad: Bool)
    func configureNews(with articlesData: [ArticleData], isMoreLoad: Bool)
    
    func updateUI()
    func showErrorMessage(_ error: String)
    func showLoadingIndicator()
    
    func numberOfItems() -> Int
    func configure(cell: ArticleCellProtocol, at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
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

// MARK: - NewsPresenterProtocol

extension NewsPresenter: NewsPresenterProtocol {
    
    // News - Loading and Configuration
    
    func updateNews(isMoreLoad: Bool) {
        interactor.loadNews(isMoreLoad: isMoreLoad)
    }
    
    func configureDate(dateString: String?) -> Date? {
        guard let dateString else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else {
            print("Failed to convert to Date")
            return nil
        }
        return date
    }
    
    func configureNews(with articlesData: [ArticleData], isMoreLoad: Bool) {
        let articles = articlesData.map {
            let date = configureDate(dateString: $0.pubDate)
            return Article(
                title: $0.title ?? "",
                description: $0.description ?? "",
                content: $0.content ?? "",
                category: $0.category?.first?.capitalized ?? "Other",
                link: $0.link,
                creator: $0.creator?.first,
                date: date,
                imageUrl: $0.imageUrl
            )
        }
        if isMoreLoad {
            articles.forEach { news.append($0) }
        } else {
            news = articles
        }
        interactor.loadImages(for: articles)
        interactor.synchronizeWithLocalData(articles: articles)
    }
    
    // UI Updating
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {return }
            view?.updateUI()
            view?.stopRefreshing()
            view?.hideLoadingIndicator()
        }
    }
    
    func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {return }
            view?.showLoadingIndicator()
        }
    }
    
    func showErrorMessage(_ error: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            view?.showErrorMessage(error)
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
