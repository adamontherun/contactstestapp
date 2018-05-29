import UIKit

class ContactsTableViewController: UITableViewController {
    
    private let contactsStore = ContactsStore()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        contactsStore.fetchContacts()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsStore.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let contact = contactsStore.contacts[indexPath.row]
        cell.textLabel?.text = contact.firstName
        return cell
    }
 
    // MARK: - Observers
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactsFetched(notification:)), name: .contactsFetched, object: nil)
    }
    
    @objc private func handleContactsFetched(notification: Notification) {
        tableView.reloadData()
    }
}
