//
//  Router.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

protocol AppRouterProtocol: AnyObject {
    func setupTabController()
}

final class AppRouter: AppRouterProtocol {
    
    private let tabBarController: UITabBarController
    private let newsService: NewsServiceProtocol
    
    init(tabBarController: UITabBarController, newsService: NewsServiceProtocol) {
        self.tabBarController = tabBarController
        self.newsService = newsService
    }
    
    func setupTabController() {
        let pages: [TabBarPage] = [.news, .favorites]
            .sorted(by: { $0.pageOrderNumber < $1.pageOrderNumber })
        let controllers = pages.map { createController(for: $0)}
        prepareTabBarController(with: controllers)
    }
    
    private func createController(for page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(
            title: page.pageTitle,
            image: page.pageIcon,
            tag: page.pageOrderNumber
        )
        switch page {
        case .news:
            let newsRouter = NewsRouter(navigationController, newsService)
            let controller = ModuleBuilder.createNewsModule(router: newsRouter, newsService: newsService)
            navigationController.setViewControllers([controller], animated: false)
        case .favorites:
            let favoritesRouter = NewsRouter(navigationController, newsService)
            let controller = ModuleBuilder.createFavoritesModule(router: favoritesRouter, newsService: newsService)
            navigationController.setViewControllers([controller], animated: false)
        }
        return navigationController
    }
    
    private func prepareTabBarController(with controllers: [UIViewController]) {
        tabBarController.setViewControllers(controllers, animated: false)
    }
}
