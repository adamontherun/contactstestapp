import UIKit

enum ContactFormState {
    case undefined
    case new
    case edit(contact: Contact)
}

class ContactFormTableViewController: UITableViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    private var contactFormState = ContactFormState.undefined
    
    // MARK: - Public
    
    func configure(_ contactFormState: ContactFormState) {
        self.contactFormState = contactFormState
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    // MARK: - Actions
    
    @IBAction func handleSaveWasTapped(_ sender: Any) {
    }
    

    // MARK: - UI Configuration
    
    private func configureUI() {
        switch contactFormState {
        case .undefined:
            return
        case .new:
            navigationItem.title = "Add Contact"
        case .edit(let contact):
            navigationItem.title = "Edit Contact"
            fillTextFields(with: contact)
        }
    }
    
    private func fillTextFields(with contact: Contact) {
        firstNameTextField.text = contact.firstName
        lastNameTextField.text = contact.lastName
        phoneNumberTextField.text = contact.phoneNumber
        address1TextField.text = contact.streetAddress1
        address2TextField.text = contact.streetAddress2
        cityTextField.text = contact.city
        stateTextField.text = contact.state
        zipcodeTextField.text = contact.zipcode
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
    }
}
