import UIKit
import CoreData


protocol CoreDataControllerDelegate: class {
    func coreDataControllerDidInitializeStores(_ controller: CoreDataController)
    func coreDataControllerDidFetchContacts(_ controller: CoreDataController)
}

class CoreDataController: NSObject {
    
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Contact>?
    weak var delegate: CoreDataControllerDelegate!

    init(delegate: CoreDataControllerDelegate) {
        self.delegate = delegate
        let persistentContainer = NSPersistentContainer(name: "Model")
        super.init()
        persistentContainer.loadPersistentStores() { [weak self](description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            //print(persistentContainer.persistentStoreCoordinator.persistentStores.first!.url!)
            self?.managedObjectContext = persistentContainer.viewContext
            DispatchQueue.main.async {
                guard let this = self else { return }
                this.delegate.coreDataControllerDidInitializeStores(this)
            }
        }
    }
    
    func createContacts(from jsonCollection: [Any]) {
        jsonCollection.forEach { createContact(from: $0 as! [String: Any]) }
        saveContext()
    }
    
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        let departmentSort = NSSortDescriptor(key: "firstName", ascending: true)
        request.sortDescriptors = [departmentSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Contact>
        fetchedResultsController!.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
            print(fetchedResultsController?.fetchedObjects ?? "MA")
            delegate.coreDataControllerDidFetchContacts(self)
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    private func createContact(from json: [String: Any]) {
        guard let contactID = json["contactID"] as? String else { return }
        let state = json["state"] as? String
        let city = json["city"] as? String
        let streetAddress1 = json["streetAddress1"] as? String
        let streetAddress2 = json["streetAddress2"] as? String
        let phoneNumber = json["phoneNumber"] as? String
        let firstName = json["firstName"] as? String
        let lastName = json["lastName"] as? String
        let zipcode = json["zipcode"] as? String
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: managedObjectContext) as! Contact
        contact.contactID = contactID
        contact.state = state
        contact.city = city
        contact.streetAddress1 = streetAddress1
        contact.streetAddress2 = streetAddress2
        contact.phoneNumber = phoneNumber
        contact.firstName = firstName
        contact.lastName = lastName
        contact.zipcode = zipcode
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}

extension CoreDataController: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(controller.fetchedObjects)
    }

}
