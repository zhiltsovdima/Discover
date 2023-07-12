//
//  NewsInteractor.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import Foundation

protocol NewsInteractorProtocol: AnyObject {
    func fetchNews()
}

final class NewsInteractor {
    weak var presenter: NewsPresenterProtocol!
    
    private let newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
    }
}

extension NewsInteractor: NewsInteractorProtocol {
    
    func fetchNews() {
        newsService.getNews { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newsData):
                let articles = newsData.results
                presenter.configureItems(with: articles)
            case .failure(let error):
                print(error)
            }
        }
    }
}
