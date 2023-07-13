//
//  Article + ext.swift
//  Discover
//
//  Created by Dima Zhiltsov on 13.07.2023.
//

import Foundation

extension Article: Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.content == rhs.content &&
        lhs.category == rhs.category &&
        lhs.date == rhs.date &&
        lhs.creator == rhs.creator
    }
}

extension Article: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(content)
        hasher.combine(date)
        hasher.combine(category)
        hasher.combine(creator)
    }
}
