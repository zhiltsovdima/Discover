//
//  NewsService.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit
import CoreData

protocol NewsServiceProtocol: AnyObject {
    func loadNews(nextPage: String?, completion: @escaping (Result<NewsData, Error>) -> Void)
    func loadImage(for article: Article, completion: @escaping ((Result<UIImage, Error>) -> Void))
    
    func saveArticleToFavorites(article: Article)
    func removeArticleFromFavorites(article: Article)
    func getFavoritesNews() -> [Article]
}

final class NewsService {
    
    private let networkManager: NetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    
    private var favoritesNews = Set<Article>()
    
    init(_ networkManager: NetworkManagerProtocol, _ coreDataManager: CoreDataManagerProtocol) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
    }
}

// MARK: - NewsServiceProtocol

extension NewsService: NewsServiceProtocol {
    
    // Interaction with the NetworkManager
    
    func loadNews(nextPage: String?, completion: @escaping (Result<NewsData, Error>) -> Void) {
        fetchData(apiEndpoint: .news(nextPage: nextPage), completion: completion)
    }
    
    func loadImage(for article: Article, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        guard let imageUrl = article.imageUrl,
              let url = URL(string: imageUrl)
        else {
            completion(.failure(NetworkError.wrongURL))
            return
        }

        networkManager.fetchData(url: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                processImageData(data, imageURL: url, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Interaction with the CoreDataManager

    func getFavoritesNews() -> [Article] {
        let coreDataArticles: [CoreDataArticle] = coreDataManager.getAll()
        let articles = coreDataArticles.map {
            let item = Article(
                title: $0.title ?? "",
                description: $0.descriptionArticle ?? "",
                content: $0.content ?? "",
                category: $0.category ?? "",
                link: $0.link,
                creator: $0.creator,
                date: $0.date,
                imageUrl: nil
            )
            if let imageData = $0.image {
                item.image = UIImage(data: imageData)
            }
            item.isFavorite = true
            item.id = $0.id
            return item
        }
        return articles
    }
    
    func saveArticleToFavorites(article: Article) {
        let coreDataArticle = CoreDataArticle(context: coreDataManager.moc)
        let imageData = article.image?.jpegData(compressionQuality: 1.0)
        
        let id = article.id ?? UUID().uuidString
        article.id = id
        
        coreDataArticle.setValuesForKeys([
            "id": id,
            "title": article.title,
            "descriptionArticle": article.description,
            "content": article.content,
            "category": article.category,
            "link": article.link as Any,
            "creator": article.creator as Any,
            "date": article.date as Any,
            "image": imageData as Any
        ])
    
        coreDataManager.save()
        makeFavorite(article)
    }

    func removeArticleFromFavorites(article: Article) {
        guard let id = article.id else {
            print(CoreDataError.idHasNotFound)
            return
        }
        coreDataManager.deleteObject(entityType: CoreDataArticle.self, by: id)
        makeUnfavorite(article)
    }
}

//MARK: - Private Methods

extension NewsService {
    
    // Data Interaction
    
    private func fetchData<T: Decodable>(apiEndpoint: APIEndpoints, completion: @escaping (Result<T, Error>) -> Void) {
        networkManager.fetchData(apiEndpoint: apiEndpoint) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                parseData(data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func parseData<T: Decodable>(_ data: Data, completion: @escaping (Result<T, Error>) -> Void) {
        let parseResult = DataCoder.decode(type: T.self, from: data)
        switch parseResult {
        case .success(let fetchedData):
            completion(.success(fetchedData))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func processImageData(_ data: Data, imageURL: URL, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        guard let image = UIImage(data: data) else {
            completion(.failure(DataCodingError.decodingToImageFailed))
            return
        }
        completion(.success(image))
    }
    
    // Favorite Interaction
    
    private func makeFavorite(_ article: Article) {
        if favoritesNews.contains(article) {
            let newsArticle = favoritesNews.first(where: { article == $0 })
            newsArticle?.isFavorite = true
        } else {
            favoritesNews.insert(article)
        }
        article.isFavorite = true
    }
    
    private func makeUnfavorite(_ article: Article) {
        article.isFavorite = false
        let newsArticle = favoritesNews.first(where: { article == $0 })
        newsArticle?.isFavorite = false
    }
}
