//
//  ArticleDetailInteractor.swift
//  Discover
//
//  Created by Dima Zhiltsov on 12.07.2023.
//

import Foundation

protocol ArticleDetailsInteractorProtocol: AnyObject {
    
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
    
}
