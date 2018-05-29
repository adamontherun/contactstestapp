import UIKit

typealias ContactsStoreCompletionHandler = () -> ()

class ContactsStore {
    
    private var coreDataController: CoreDataController!
    private var contacts = [Contact]()
    
    var contactsCount: Int {
        return contacts.count
    }
    
    // MARK: - Initializers
    
    init(completionHandler: @escaping ContactsStoreCompletionHandler) {
        coreDataController = CoreDataController { [weak self] in
            let isFirstUsage = FirstUsageManager.checkIfAppsFirstUse()
            isFirstUsage ? self?.addInitialContacts() : self?.fetchContacts()
            completionHandler()
        }
    }
    
    private func addInitialContacts() {
        
    }
    
    private func fetchContacts() {
        
    }
    
}
