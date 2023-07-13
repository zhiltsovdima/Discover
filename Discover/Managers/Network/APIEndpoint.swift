//
//  APIEndpoint.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import Foundation

enum APIEndpoints {
    
    case news(nextPage: String?)
    
    private var scheme: String {
        return "https"
    }
    
    private var host: String {
        switch self {
        case .news:
            return "newsdata.io"
        }
    }
    
    private var path: String {
        switch self {
        case .news:
            return "/api/1/news"
        }
    }
    
    private var parameters: [String: String?] {
        switch self {
        case .news(let nextPage):
            return [
                "apikey": PrivateKey.apiKey,
                "language": "en,ru",
                "page": nextPage
            ]
        }
    }
}

// MARK: - Creating URLRequest

extension APIEndpoints {
    
    func makeURLRequest() -> URLRequest {
        let url = URL(scheme: scheme, host: host, path: path, parameters: parameters)
        guard let url else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
