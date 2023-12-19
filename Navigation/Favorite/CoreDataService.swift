import CoreData
import Foundation

final class CoreDataService{
   
    static let shared = CoreDataService()
    
    private init(){}
    
    private let persistentContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name: .coreDataBaseName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error)
                assertionFailure("load PersistentStores error ")
            }
        }
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func saveContext() {
        if context.hasChanges{
            do{
                try context.save()
            } catch {
                print(error)
                assertionFailure("Save Error")
            }
        }
    }
    
}

private extension String {
    static let coreDataBaseName = "NavigationItems"
}
