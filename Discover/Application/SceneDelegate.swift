//
//  SceneDelegate.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var router: AppRouterProtocol?
    let networkManager = NetworkManager()
    let coreDataManager = CoreDataManager()
    lazy var newsService = NewsService(networkManager, coreDataManager)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = TabBarController()
        
        router = AppRouter(tabBarController: tabBarController, newsService: newsService)
        router?.setupTabController()
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }

}

