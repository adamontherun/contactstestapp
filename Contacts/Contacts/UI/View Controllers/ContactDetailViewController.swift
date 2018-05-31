//😘 it is 5/30/18

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
        configureUI()
    }
    
    // MARK: - Private
    
    private func configureUI() {
        navigationItem.title = contact.displayName
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
}
