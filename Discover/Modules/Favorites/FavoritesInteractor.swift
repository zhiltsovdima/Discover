//
//  FavoritesInteractor.swift
//  Discover
//
//  Created by Dima Zhiltsov on 12.07.2023.
//

import Foundation

protocol FavoritesInteractorProtocol: AnyObject {
    
}

final class FavoritesInteractor{
    weak var presenter: FavoritesPresenterProtocol!
    
    private let newsService: NewsServiceProtocol
    
    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
    }
}

// MARK: - FavoritesPresenterProtocol

extension FavoritesInteractor: FavoritesInteractorProtocol {
    
}
