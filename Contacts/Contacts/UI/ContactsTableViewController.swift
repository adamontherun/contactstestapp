import UIKit

class ContactsTableViewController: UITableViewController {
    
    private let contactsStore = ContactsStore()
    private lazy var contactsTableViewControllerDataSource: ContactsTableViewControllerDataSource =  {
       return ContactsTableViewControllerDataSource(contactsStore)
    }()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addObservers()
        contactsStore.fetchContacts()
    }
    
    // MARK: - UI Configuration
    
    private func configureTableView() {
        tableView.dataSource = contactsTableViewControllerDataSource
        tableView.tableFooterView = UIView()
    }
 
    // MARK: - Observers
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactsFetched(notification:)), name: .contactsFetched, object: nil)
    }
    
    @objc private func handleContactsFetched(notification: Notification) {
        tableView.reloadData()
    }
}
