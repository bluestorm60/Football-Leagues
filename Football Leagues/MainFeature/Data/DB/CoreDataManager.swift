//
//  CoreDataManager.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 16/09/2023.
//

import CoreData

public class CoreDataManager {

    // MARK: - Properties
    public static let shared = CoreDataManager()
    var persistentContainer = NSPersistentContainer(name: Constants.modelName.rawValue)
    var viewContextBackground = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    private lazy var persistentCoordinator = persistentContainer.persistentStoreCoordinator

    // MARK: - Init
    #if TESTING
    init() {
        setPersistentContainer()
    }
    #else
    private init() {
        setPersistentContainer()
    }
    #endif

    // MARK: - Functions
    private func setPersistentContainer() {
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
            print(description.url)
        }
        let viewContext = persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        viewContextBackground.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        viewContextBackground.parent = viewContext
    }
}


extension CoreDataManager{
    public func reset() {
        viewContextBackground.performAndWait {
            // We have just one persistent store
            guard let loggerStore = persistentCoordinator.persistentStores.first else { return }
            deletePersistentStore(loggerStore)
            setPersistentContainer()
        }
    }

    private func deletePersistentStore(_ store: NSPersistentStore) {
        do{
            try persistentCoordinator.destroyPersistentStore(at: store.url!, ofType: store.type, options: nil)
        }
        catch {
            print(error)
        }
    }
}
