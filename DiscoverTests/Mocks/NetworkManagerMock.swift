//
//  NetworkManagerMock.swift
//  DiscoverTests
//
//  Created by Dima Zhiltsov on 13.07.2023.
//

import Foundation
@testable import Discover

final class NetworkManagerMock: NetworkManagerProtocol {
    
    var expectedResult: Result<Data, NetworkError>?
        
    func fetchData(apiEndpoint: Discover.APIEndpoints, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let expectedResult else {
            completion(.failure(.unexpectedResponse))
            return
        }
        completion(expectedResult)
    }
    
    func fetchData(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let expectedResult else {
            completion(.failure(.unexpectedResponse))
            return
        }
        completion(expectedResult)
    }
}
