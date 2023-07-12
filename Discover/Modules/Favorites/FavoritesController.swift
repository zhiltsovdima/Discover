//
//  FavoritesController.swift
//  Discover
//
//  Created by Dima Zhiltsov on 12.07.2023.
//

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    
}

final class FavoritesController: UIViewController {
    var presenter: FavoritesPresenterProtocol!
}

// MARK: - FavoritesViewProtocol

extension FavoritesController: FavoritesViewProtocol {
    
}
