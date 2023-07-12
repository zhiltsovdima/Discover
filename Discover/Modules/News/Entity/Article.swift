//
//  Article.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import Foundation

final class Article {
    let title: String
    let description: String
    let date: String
    
    init(title: String, description: String, date: String) {
        self.title = title
        self.description = description
        self.date = date
    }
    
}
