//
//  NetworkManager.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import Foundation

enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}

// MARK: - NetworkManagerProtocol

protocol NetworkManagerProtocol {
    func fetchData(apiEndpoint: APIEndpoints, completion: @escaping (Result<Data, NetworkError>) -> Void)
    func fetchData(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

// MARK: - NetworkManager

final class NetworkManager: NetworkManagerProtocol {
    
    private let urlSession: URLSession
        
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchData(apiEndpoint: APIEndpoints, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let request = apiEndpoint.makeURLRequest()
        fetchData(request: request, completion: completion)
    }
    
    func fetchData(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let request = URLRequest(url: url)
        fetchData(request: request, completion: completion)
    }
    
    private func fetchData(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self else { return }
            do {
                let safeData = try processResponseData(data, response)
                completion(.success(safeData))
            } catch {
                let netError = error as! NetworkError
                completion(.failure(netError))
            }
        }
        task.resume()
    }
    
    private func processResponseData(_ data: Data?, _ response: URLResponse?) throws  -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.failed
        }
        switch httpResponse.statusCode {
        case 200...299:
            guard let data else { throw NetworkError.noData }
            return data
        case 401, 403:
            throw NetworkError.authenticationError(statusCode: httpResponse.statusCode)
        case 404:
            throw NetworkError.unavailable(statusCode: httpResponse.statusCode)
        case 408:
            throw NetworkError.timeout(statusCode: httpResponse.statusCode)
        case 429:
            throw NetworkError.tooManyRequests(statusCode: httpResponse.statusCode)
        case 400...599:
            throw NetworkError.badRequest(statusCode: httpResponse.statusCode)
        case 503:
            throw NetworkError.unavailable(statusCode: httpResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.failed
        }
    }
}
