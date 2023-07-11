//
//  NetworkError.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import Foundation

enum NetworkError: Error, Equatable {
    case noInternet
    case timeout(statusCode: Int)
    case authenticationError(statusCode: Int)
    case unavailable(statusCode: Int)
    case tooManyRequests(statusCode: Int)
    case badRequest(statusCode: Int)
    case wrongURL
    case failed
    case noData
    case serverError(statusCode: Int)
    
    var description: String {
        switch self {
        case .noInternet:
            return "Please, check your network connection"
        case .timeout(let statusCode):
            return "\(statusCode) Timeout"
        case .authenticationError(let statusCode):
            return "\(statusCode) You need to be authenticated first"
        case .unavailable(let statusCode):
            return "\(statusCode) Service unavailable"
        case .tooManyRequests(let statusCode):
            return "\(statusCode) Too many requests. You reached your per minute or per day rate limit"
        case .badRequest(let statusCode):
            return "\(statusCode) Bad request"
        case .wrongURL:
            return "Wrong URL"
        case .failed:
            return "Network request failed"
        case .noData:
            return "Response returned with no data to decode"
        case .serverError(let statusCode):
            return "Server error. Status code: \(statusCode)"
        }
    }
}
