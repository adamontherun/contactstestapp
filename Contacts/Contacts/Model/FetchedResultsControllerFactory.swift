import Foundation
import CoreData

struct FetchedResultsControllerFactory {
    
    static func make(_ delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext)-> NSFetchedResultsController<Contact> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: .Contact)
        let firstNameSort = NSSortDescriptor(key: .sortDescriptorFirstName, ascending: true)
        let lastNameSort = NSSortDescriptor(key: .sortDescriptorLastName, ascending: true)
        request.sortDescriptors = [firstNameSort, lastNameSort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<Contact>
        fetchedResultsController.delegate = delegate
        return fetchedResultsController
    }
}
