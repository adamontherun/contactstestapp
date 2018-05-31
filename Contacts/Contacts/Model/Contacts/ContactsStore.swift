import UIKit

enum ContactStoreUpdate {
    case added(indexPath: IndexPath)
    case updated(indexPath: IndexPath, contact: Contact)
    case deleted(indexPath: IndexPath)
}

class ContactsStore {
    
    private lazy var coreDataController: CoreDataController = {
       return CoreDataController(delegate: self)
    }()
    
    var contacts: [Contact] {
        return coreDataController.fetchedResultsController?.fetchedObjects ?? [Contact]()
    }
    
    // MARK: - Public
    
    func createContact(state: String?, city: String?, streetAddress1: String?, streetAddress2: String?, phoneNumber: String?, firstName: String?, lastName: String?, zipcode: String?) {
        coreDataController.createContact(state: state, city: city, streetAddress1: streetAddress1, streetAddress2: streetAddress2, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, zipcode: zipcode)
    }
    
    func update(contact: Contact, state: String?, city: String?, streetAddress1: String?, streetAddress2: String?, phoneNumber: String?, firstName: String?, lastName: String?, zipcode: String?) {
        coreDataController.edit(contact: contact, state: state, city: city, streetAddress1: streetAddress1, streetAddress2: streetAddress2, phoneNumber: phoneNumber, firstName: firstName, lastName: lastName, zipcode: zipcode)
    }
    
    func delete(contact: Contact) {
        coreDataController.delete(contact: contact)
    }
    
    // MARK: - Private
    
    private func addInitialContacts() {
        let json = JSONFetcher.fetchInitialContactsJSON()
        coreDataController.createContacts(from: json)
        FirstUsageManager.markAsUsed()
        fetchContacts()
    }
    
    private func fetchContacts() {
        coreDataController.initializeFetchedResultsController()
    }
}

extension ContactsStore: CoreDataControllerDelegate {

    
    
    func coreDataControllerDidInitializeStores(_ controller: CoreDataController) {
        let isFirstUsage = FirstUsageManager.checkIfAppsFirstUse()
        isFirstUsage ? addInitialContacts() : fetchContacts()
    }
    
    func coreDataControllerDidFetchContacts(_ controller: CoreDataController) {
        NotificationCenter.default.post(name: .contactsFetched, object: nil)
    }
    
    func coreDataController(_ controller: CoreDataController, addedContactAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .contactUpdated, object: nil, userInfo: ["type" : ContactStoreUpdate.added(indexPath: indexPath)])
    }
    func coreDataController(_ controller: CoreDataController, updatedContact contact: Contact, at indexPath: IndexPath) {
        NotificationCenter.default.post(name: .contactUpdated, object: nil, userInfo: ["type" : ContactStoreUpdate.updated(indexPath: indexPath, contact: contact)])
    }
    
    func coreDataController(_ controller: CoreDataController, deletedContactAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .contactUpdated, object: nil, userInfo: ["type" : ContactStoreUpdate.deleted(indexPath: indexPath)])
    }
}
