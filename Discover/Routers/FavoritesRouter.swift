//
//  FavoritesRouter.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

protocol FavoritesRouterProtocol: AnyObject {
    
}

final class FavoritesRouter {
    private let navigationController: UINavigationController
        
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension FavoritesRouter: FavoritesRouterProtocol {
    
}
