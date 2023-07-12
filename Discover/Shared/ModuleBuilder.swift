//
//  ModuleBuilder.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

protocol ModuleBuilderProtocol: AnyObject {
    static func createNewsModule(router: NewsRouterProtocol, newsService: NewsServiceProtocol) -> UIViewController & NewsViewProtocol
}

final class ModuleBuilder: ModuleBuilderProtocol {

    static func createNewsModule(router: NewsRouterProtocol, newsService: NewsServiceProtocol) -> UIViewController & NewsViewProtocol {
        let interactor = NewsInteractor(newsService: newsService)
        let presenter = NewsPresenter(router: router)
        let view = NewsViewController()

        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        view.presenter = presenter

        return view
    }

    static func createFavoritesModule(router: FavoritesRouterProtocol, newsService: NewsServiceProtocol) -> UIViewController & FavoritesViewProtocol {
        let interactor = FavoritesInteractor(newsService: newsService)
        let presenter = FavoritesPresenter(router: router)
        let view = FavoritesController()

        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        view.presenter = presenter

        return view
    }
}

