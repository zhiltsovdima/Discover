//
//  GetJSONMock.swift
//  DiscoverTests
//
//  Created by Dima Zhiltsov on 13.07.2023.
//


import UIKit
@testable import Discover

struct GetJSONMock {
    
    static let fileName = "NewsJsonMock"
        
    static func getDataFromJsonFile() -> Data {
        guard let url = Bundle(for: NewsServiceTests.self).url(forResource: fileName, withExtension: "json") else {
            fatalError("Couldn't find \(fileName).json file")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Couldn't convert json into data")
        }
        return data
    }
    
    static func createNewsDataFromJson() -> NewsData {
        let data = getDataFromJsonFile()
        guard let newsData = try? JSONDecoder().decode(NewsData.self, from: data) else { fatalError("Couldn't decode jsonData") }
        return newsData
    }
}
