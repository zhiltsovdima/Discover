//
//  CoreDataManager.swift
//  Discover
//
//  Created by Dima Zhiltsov on 13.07.2023.
//

import CoreData
import UIKit

protocol CoreDataManagerProtocol: AnyObject {
    var moc: NSManagedObjectContext { get }
    
    func getObject<T: NSManagedObject>(_ plantID: NSManagedObjectID) -> T?
    func getAll<T: NSManagedObject>() -> [T]
    func save()
    func deleteObject<T: NSManagedObject>(entityType: T.Type, by id: String)
    func deleteObject<T: NSManagedObject>(_ object: T)
}

final class CoreDataManager {
        
    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "News")
        persistentContainer.loadPersistentStores { _, error in
            guard let error else { return }
            print(CoreDataError.failedLoadPersistentStore)
        }
        return persistentContainer
    }()
    
    var moc: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}

extension CoreDataManager: CoreDataManagerProtocol {
    
    func save() {
        do {
            try moc.save()
        } catch {
            print(CoreDataError.saveError)
        }
    }
    
    func getObject<T: NSManagedObject>(_ objectID: NSManagedObjectID) -> T? {
        do {
            let object = try moc.existingObject(with: objectID) as? T
            return object
        } catch {
            print(CoreDataError.existingObjectNotFound)
        }
        return nil
    }
    
    func getAll<T: NSManagedObject>() -> [T] {
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: "\(T.self)")
            return try moc.fetch(fetchRequest)
        } catch {
            print(CoreDataError.fetchError)
            return []
        }
    }
    
    func deleteObject<T: NSManagedObject>(entityType: T.Type, by id: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entityType))
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try moc.fetch(fetchRequest)
            guard let object = results.first as? T else { return }
            deleteObject(object)
        } catch {
            print(error)
        }
    }
    
    func deleteObject<T: NSManagedObject>(_ object: T) {
        moc.delete(object)
        save()
    }
}
