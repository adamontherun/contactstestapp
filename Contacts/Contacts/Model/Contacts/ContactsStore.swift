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
    
    func createContact(state: String?, city: String?, streetAddress1: String?, streetAddress2: String?, phoneNumber: String?, firstName: String?, lastName: String?, zipcode: String?) {
        coreDataController.createContact(state: state, city: city, streetAddress1: streetAddress1, streetAddress2: streetAddress2, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, zipcode: zipcode)
    }
}

extension ContactsStore: CoreDataControllerDelegate {
    
    func coreDataControllerDidInitializeStores(_ controller: CoreDataController) {
        let isFirstUsage = FirstUsageManager.checkIfAppsFirstUse()
        isFirstUsage ? addInitialContacts() : fetchContacts()
    }
    
    func coreDataController(_ controller: CoreDataController, didFetch contacts: [Contact]) {
        self.contacts = contacts
        NotificationCenter.default.post(name: .contactsFetched, object: nil)
    }
}
