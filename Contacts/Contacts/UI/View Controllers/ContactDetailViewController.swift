import UIKit

class ContactDetailViewController: UIViewController {
    
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    
    private var contactsStore: ContactsStore!
    private var contact: Contact!
    
    // MARK: - Public
    
    func configure(_ contact: Contact, contactsStore: ContactsStore) {
        self.contact = contact
        self.contactsStore = contactsStore
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        configureUI()
    }
    
    // MARK: - Action
    
    @IBAction func handleTrashTapped(_ sender: Any) {
        contactsStore.delete(contact: contact)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Observers
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactUpdated(notification:)), name: .contactUpdated, object: nil)
    }
    
    @objc private func handleContactUpdated(notification: Notification) {
        guard let info = notification.userInfo,
            let contactStoreUpdate = info[String.contactStoreUpdate] as? ContactStoreUpdate else { return }
        if case let ContactStoreUpdate.updated(_, contact) = contactStoreUpdate {
            self.contact = contact
            configureUI()
        }
    }
    
    // MARK: - Private
    
    private func configureUI() {
        navigationItem.title = contact.displayName
        configureLabels()
    }
    
    private func configureLabels() {
        labels.forEach { $0.text = nil }
        firstNameLabel.text = contact.firstName
        lastNameLabel.text = contact.lastName
        phoneNumberLabel.text = contact.phoneNumber
        address1Label.text = contact.streetAddress1
        address2Label.text = contact.streetAddress2
        cityLabel.text = contact.city
        stateLabel.text = contact.state
        zipcodeLabel.text = contact.zipcode
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .segueFromDetailToForm {
            guard let contactFormTableViewController = segue.destination as? ContactFormTableViewController else { fatalError("Expected a contact form tvc") }
            contactFormTableViewController.configure(.edit(contact: contact), contactsStore: contactsStore)
        }
    }
}
