//
//  NewsService.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import UIKit

protocol NewsServiceProtocol: AnyObject {
    func getNews(completion: @escaping (Result<NewsData, Error>) -> Void)
}

final class NewsService {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

// MARK: - NewsServiceProtocol

extension NewsService: NewsServiceProtocol {
    
    func getNews(completion: @escaping (Result<NewsData, Error>) -> Void) {
        fetchData(apiEndpoint: .news, completion: completion)
    }
    
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
}
