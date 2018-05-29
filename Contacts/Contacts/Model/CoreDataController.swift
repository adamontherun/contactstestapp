import UIKit
import CoreData

typealias CoreDataControllerCompletionHandler = () -> ()

class CoreDataController: NSObject {
    let managedObjectContext: NSManagedObjectContext
    
    init(completionHandler: @escaping CoreDataControllerCompletionHandler) {
        let persistentContainer = NSPersistentContainer(name: "Model")
        managedObjectContext = persistentContainer.viewContext
        persistentContainer.loadPersistentStores() {(description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            DispatchQueue.main.async {
                completionHandler()
            }
        }
        super.init()
    }
}
