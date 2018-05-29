import UIKit

class ContactsTableViewController: UITableViewController {
    
    private var contactsStore: ContactsStore!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        contactsStore = ContactsStore(completionHandler: { [weak self] in
            self?.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsStore.contactsCount
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */


}
