//
//  NewsRouter.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

protocol NewsRouterProtocol: AnyObject {
}

final class NewsRouter {
    private let navigationController: UINavigationController
        
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

extension NewsRouter: NewsRouterProtocol {
    
}
