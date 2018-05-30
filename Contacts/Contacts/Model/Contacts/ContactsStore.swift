import UIKit

class ContactsStore {
    
    private var coreDataController: CoreDataController!
    var contacts = [Contact]()

    // MARK: - Initializers
    
    init() {
        coreDataController = CoreDataController(delegate: self)
    }
    
    private func addInitialContacts() {
        let json = JSONFetcher.fetchInitialContactsJSON()
        coreDataController.createContacts(from: json)
        FirstUsageManager.markAsUsed()
        fetchContacts()
    }
    
    func fetchContacts() {
        coreDataController.initializeFetchedResultsController()
    }
}

extension ContactsStore: CoreDataControllerDelegate {
    func coreDataControllerDidInitializeStores(_ controller: CoreDataController) {
        let isFirstUsage = FirstUsageManager.checkIfAppsFirstUse()
        isFirstUsage ? addInitialContacts() : fetchContacts()
    }
    
    func coreDataControllerDidFetchContacts(_ controller: CoreDataController) {
        guard let fetchedContacts = coreDataController.fetchedResultsController?.fetchedObjects else { return }
        contacts = fetchedContacts
        NotificationCenter.default.post(name: .contactsFetched, object: nil)
    }
}
