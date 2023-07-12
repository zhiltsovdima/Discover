//
//  R.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

enum R {
    
    // MARK: - Images
    
    enum Images {
        static let news = UIImage(systemName: "newspaper")!
        static let favorites = UIImage(systemName: "star.fill")!
    }
    
    // MARK: - Strings

    enum Strings {
        static let appTitle = "Discover"
        
        enum TabBar {
            static let news = "News"
            static let favorites = "Favorites"
        }
    }
    
    // MARK: - Colors

    enum Colors {
        
    }
    
    // MARK: - Identifiers

    enum Identifiers {
        static let articleCell = "ArticleCell"
    }
}
