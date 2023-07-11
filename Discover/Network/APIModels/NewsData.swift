//
//  NewsData.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import Foundation

struct NewsData: Codable {
    let results: [ArticleData]
}

struct ArticleData: Codable {
    var title: String?
    var link: String?
    var description: String?
    var content: String?
    var pubDate: String?
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case title, link, description, content, pubDate
        case imageUrl = "image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.link = try container.decodeIfPresent(String.self, forKey: .link)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.pubDate = try container.decodeIfPresent(String.self, forKey: .pubDate)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
    }
}
