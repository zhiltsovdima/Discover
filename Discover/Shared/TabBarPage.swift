//
//  TabBarPage.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit.UIImage

enum TabBarPage {
    case news
    case favorites
    
    var pageOrderNumber: Int {
        switch self {
        case .news:
            return 0
        case .favorites:
            return 1
        }
    }
    
    var pageIcon: UIImage? {
        switch self {
        case .news:
            return R.Images.news
        case .favorites:
            return R.Images.favoritesFill
        }
    }
    
    var pageTitle: String {
        switch self {
        case .news:
            return R.Strings.TabBar.news
        case .favorites:
            return R.Strings.TabBar.favorites
        }
    }
}
