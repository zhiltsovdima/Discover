//
//  URL + ext.swift
//  Discover
//
//  Created by Dima Zhiltsov on 11.07.2023.
//

import Foundation

extension URL {
    init?(scheme: String, host: String, path: String, parameters: [String: String?]? = nil) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        if let parameters {
            components.setQueryItems(with: parameters)
        }
        guard let urlString = components.url?.absoluteString else { return nil }
        self.init(string: urlString)
    }
}
