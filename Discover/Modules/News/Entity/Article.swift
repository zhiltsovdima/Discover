//
//  Article.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

final class Article {
    let title: String
    let description: String
    let content: String
    let category: String
    let date: Date?
    let imageUrl: String?
    
    var image: UIImage?
    
    var dateString: String {
        guard let date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    var timeAgo: String {
        guard let date else { return "" }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: Date())
        
        if let days = components.day, days > 0 {
            return "\(days) " + (days == 1 ? "day ago" : "days ago")
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) " + (hours == 1 ? "hour ago" : "hours ago")
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) " + (minutes == 1 ? "minute ago" : "minutes ago")
        } else {
            return "Rigth now"
        }
    }
    
    init(title: String, description: String, content: String, category: String, date: Date?, imageUrl: String?) {
        self.title = title
        self.description = description
        self.content = content
        self.category = category
        self.date = date
        self.imageUrl = imageUrl
    }
    
}
