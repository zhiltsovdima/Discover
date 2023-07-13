//
//  CoreDataError.swift
//  Discover
//
//  Created by Dima Zhiltsov on 13.07.2023.
//

import Foundation

enum CoreDataError: Error, Equatable {
    case failedLoadPersistentStore
    case saveError
    case existingObjectNotFound
    case fetchError
    case idHasNotFound
    
    var description: String {
        switch self {
        case .failedLoadPersistentStore:
            return "Failed to load the persistent store"
        case .saveError:
            return "Failed to save the changes"
        case .existingObjectNotFound:
            return "The requested object does not exist"
        case .fetchError:
            return "Failed to fetch objects from the data store"
        case .idHasNotFound:
            return "Item Id has not found. Failed deleting file from data base"
        }
    }
}
