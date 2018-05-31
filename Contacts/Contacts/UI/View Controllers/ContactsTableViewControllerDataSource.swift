import UIKit

class ContactsTableViewControllerDataSource: NSObject, UITableViewDataSource {
    
    private var contactsStore: ContactsStore!
    
    // MARK: - Initializers
    
    init(_ contactsStore: ContactsStore) {
        self.contactsStore = contactsStore
    }
    
    // MARK: - Public
    
    func contact(at indexPath: IndexPath)-> Contact? {
        if contactsStore.contacts.indices.contains(indexPath.row) { return contactsStore.contacts[indexPath.row] }
        else { return nil }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsStore.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = contactsStore.contacts[indexPath.row]
        cell.textLabel?.text = contact.displayName
        return cell
    }
}
