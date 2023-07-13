//
//  NewsPresenterMock.swift
//  DiscoverTests
//
//  Created by Dima Zhiltsov on 13.07.2023.
//

import UIKit
@testable import Discover

final class NewsPresenterMock: NewsPresenterProtocol {
    
    var isConfigureNewsCalled = false
    var configureNewsArticles: [ArticleData]?
    var configureNewsIsMoreLoad: Bool?
    
    func updateNews(isMoreLoad: Bool) {
        
    }
    
    func configureNews(with articlesData: [ArticleData], isMoreLoad: Bool) {
        isConfigureNewsCalled = true
        configureNewsArticles = articlesData
        configureNewsIsMoreLoad = isMoreLoad
    }
    
    func updateUI() {
        
    }
    
    func showErrorMessage(_ error: String) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func numberOfItems() -> Int {
        return 0
    }
    
    func configure(cell: Discover.ArticleCellProtocol, at indexPath: IndexPath) {
        
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        
    }
    
    
   
}
