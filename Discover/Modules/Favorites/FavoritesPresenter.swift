//
//  FavoritesPresenter.swift
//  Discover
//
//  Created by Dima Zhiltsov on 12.07.2023.
//

import Foundation

protocol FavoritesPresenterProtocol: AnyObject {
    
}

final class FavoritesPresenter {
    weak var view: FavoritesViewProtocol?
    var interactor: FavoritesInteractorProtocol!
    
    private let router: FavoritesRouterProtocol
    
    init(router: FavoritesRouterProtocol) {
        self.router = router
    }
}

// MARK: - FavoritesPresenterProtocol

extension FavoritesPresenter: FavoritesPresenterProtocol {
    
}
