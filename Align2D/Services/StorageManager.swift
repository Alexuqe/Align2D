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
        backgroundViewContext.perform { [weak self] in
            guard let self else { return }

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
    }

    func saveVector(vector: VectorModel, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundViewContext.perform { [weak self] in
            guard let self else { return }

            let entity = VectorEntity(context: self.backgroundViewContext)
            entity.id = vector.id
            entity.startX = Double(vector.startX)
            entity.startY = Double(vector.startY)
            entity.endX = Double(vector.endX)
            entity.endY = Double(vector.endY)
            entity.color = vector.color

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

    func delete(vector: VectorEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundViewContext.perform { [weak self] in
            guard let self else { return }
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

    func updateVector(
        id: UUID,
        startX: Double,
        startY: Double,
        endX: Double,
        endY: Double,
        completion: @escaping (Result<Void, Error>) -> Void) {
            backgroundViewContext.perform { [weak self] in
                guard let self = self else { return }

                let request: NSFetchRequest<VectorEntity> = VectorEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

                do {
                    let results = try self.backgroundViewContext.fetch(request)

                    if let vector = results.first {
                        vector.startX = startX
                        vector.startY = startY
                        vector.endX = endX
                        vector.endY = endY

                        try self.backgroundViewContext.save()
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(
                                .failure(
                                    NSError(
                                        domain: "UpdateError",
                                        code: 404,
                                        userInfo: [NSLocalizedDescriptionKey: "Vector not found"])))
                        }
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
