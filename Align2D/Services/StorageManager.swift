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

    func fetchVectors(completion: @escaping (Result<[VectorDataModel], Error>) -> Void)  {
        let fetchRequest = VectorEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        backgroundViewContext.perform {
            do {
                let vectorEntities = try self.backgroundViewContext.fetch(fetchRequest)
                let vectors = vectorEntities.map { entity in
                    VectorDataModel(
                        id: entity.id ?? UUID(),
                        startPoint: CGPoint(x: entity.startX, y: entity.startY),
                        endPoint: CGPoint(x: entity.endX, y: entity.endY),
                        color: UIColor(hexString: entity.color ?? "#FFFFFF"))
                }
                DispatchQueue.main.async {
                    completion(.success(vectors))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func saveVector(model: VectorDataModel, completion: @escaping (Result<Void,Error>) -> Void) {
        backgroundViewContext.perform {
            let vectorEntity = VectorEntity(context: self.backgroundViewContext)
            vectorEntity.id = model.id
            vectorEntity.startX = model.startPoint.x
            vectorEntity.startY = model.startPoint.y
            vectorEntity.endX = model.endPoint.x
            vectorEntity.endY = model.endPoint.y
            vectorEntity.color = model.color.hexString
        }

        do {
            try self .backgroundViewContext.save()
            DispatchQueue.main.async {
                completion(.success(()))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }

    func deleteVector(by id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let fetchRequest = VectorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        backgroundViewContext.perform {
            do {
                let results = try self.backgroundViewContext.fetch(fetchRequest)
                for vector in results {
                    self.backgroundViewContext.delete(vector)
                }

                try self.backgroundViewContext.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
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
