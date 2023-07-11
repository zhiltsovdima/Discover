//
//  DataCoderError.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import Foundation

enum DataCodingError: Error {
    case decodingFailed
    case decodingToImageFailed
    case encodingFailed
    
    var description: String {
        switch self {
        case .decodingFailed:
            return "Failed to decode data"
        case .decodingToImageFailed:
            return "Failed to decode data to Image"
        case .encodingFailed:
            return "Failed to encode"
        }
    }
}
