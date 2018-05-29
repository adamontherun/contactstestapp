//😘 it is 5/28/18

import UIKit

typealias ContactsStoreCompletionHandler = () -> ()

class ContactsStore: NSObject {
    
    private let coreDataController: CoreDataController
    private var contacts = [Contact]()
    
    var contactsCount: Int {
        return contacts.count
    }
    
    init(completionHandler: @escaping ContactsStoreCompletionHandler) {
        coreDataController = CoreDataController {
            completionHandler()
        }
    }
}
