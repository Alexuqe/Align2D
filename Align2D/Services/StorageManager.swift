    //
    //  Storagemanager.swift
    //  Align2D
    //
    //  Created by Sasha on 17.03.25.
    //

import CoreData
import UIKit

final class StorageManager {

        //    MARK: Properties
    static let shared = StorageManager()
    private let viewContext: NSManagedObjectContext
    private let backgroundViewContext: NSManagedObjectContext

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VectorEntity")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

        //    MARK: - Initializer
    private init() {
        viewContext = persistentContainer.viewContext
        backgroundViewContext = persistentContainer.newBackgroundContext()
        backgroundViewContext.automaticallyMergesChangesFromParent = true
    }

    //MARK: - Core Data Methods
    func fetch(completion: @escaping (Result<[VectorEntity], Error>) -> Void) {
        let fetchRequest = VectorEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let vectors = try self.backgroundViewContext.fetch(fetchRequest)
            DispatchQueue.main.async {
                completion(.success(vectors))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }

    func saveVector(vector: VectorModel, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundViewContext.perform {
            let entity = VectorEntity(context: self.backgroundViewContext)
            entity.id = vector.id
            entity.startX = Double(vector.startX)
            entity.startY = Double(vector.startY)
            entity.endX = Double(vector.endX)
            entity.endY = Double(vector.endY)
            entity.color = vector.color.hexString

            do {
                try self.backgroundViewContext.save()
                completion(.success(()))
            } catch {
                self.backgroundViewContext.rollback()
                completion(.failure(error))
            }
        }
    }

    func delete(vector: VectorEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundViewContext.perform {
            self.backgroundViewContext.delete(vector)
            do {
                try self.backgroundViewContext.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                self.backgroundViewContext.rollback()
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

    // MARK: - Core Data Saving support
extension StorageManager {
    
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
