//
//  CoreDataManagerMock.swift
//  DiscoverTests
//
//  Created by Dima Zhiltsov on 13.07.2023.
//

import Foundation
import CoreData
@testable import Discover

final class CoreDataManagerMock: CoreDataManagerProtocol {
    
    var storedItems: [CoreDataArticle]?
    
    var isSaveCalled = false
    var isDeleteObjectCalled = false
    
    var moc: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "News")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            if let error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()


    func getObject<T: NSManagedObject>(_ objectID: NSManagedObjectID) -> T? {
        return nil
    }

    func getAll<T: NSManagedObject>() -> [T] {
        guard let storedItems = storedItems as? [T] else { return [] }
        return storedItems
    }

    func save() {
        isSaveCalled = true
    }

    func deleteObject<T: NSManagedObject>(entityType: T.Type, by id: String) {
        isDeleteObjectCalled = true
    }

    func deleteObject<T: NSManagedObject>(_ object: T) {
    }
}
