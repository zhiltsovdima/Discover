//
//  NewsRouter.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

protocol NewsRouterProtocol: AnyObject {
    func showArticleDetails(article: Article)
    func backToRoot()
}

final class NewsRouter {
    private let navigationController: UINavigationController
    private let newsService: NewsServiceProtocol
        
    init(_ navigationController: UINavigationController, _ newsService: NewsServiceProtocol) {
        self.navigationController = navigationController
        self.newsService = newsService
    }
    
}

extension NewsRouter: NewsRouterProtocol {
    func showArticleDetails(article: Article) {
        let detailsController = ModuleBuilder.createDetailsModule(router: self, newsService: newsService, article: article)
        navigationController.viewControllers.first?.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailsController, animated: true)
    }
    
    func backToRoot() {
        navigationController.viewControllers.first?.hidesBottomBarWhenPushed = false
        navigationController.popViewController(animated: true)
    }
}
