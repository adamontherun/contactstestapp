import UIKit

enum ContactFormState {
    case undefined
    case new
    case edit(contact: Contact)
}

class ContactFormTableViewController: UITableViewController {
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    private var activeTextField: UITextField?
    private var contactFormState = ContactFormState.undefined
    private var contactsStore: ContactsStore!
    
    // MARK: - Public
    
    func configure(_ contactFormState: ContactFormState, contactsStore: ContactsStore) {
        self.contactFormState = contactFormState
        self.contactsStore = contactsStore
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        configureUI()
        configureTableView()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    // MARK: - Actions
    
    @IBAction func handleSaveWasTapped(_ sender: Any) {
        switch contactFormState {
        case .undefined:
            print("handle undefined")
        case .new:
            contactsStore.createContact(state: stateTextField.text, city: cityTextField.text, streetAddress1: address1TextField.text, streetAddress2: address2TextField.text, phoneNumber: phoneNumberTextField.text, firstName: firstNameTextField.text, lastName: lastNameTextField.text, zipcode: zipcodeTextField.text)
        case .edit(let contact):
            contactsStore.update(contact: contact, state: stateTextField.text, city: cityTextField.text, streetAddress1: address1TextField.text, streetAddress2: address2TextField.text, phoneNumber: phoneNumberTextField.text, firstName: firstNameTextField.text, lastName: lastNameTextField.text, zipcode: zipcodeTextField.text)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleBackgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        textFields.forEach{ $0.delegate = self }
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

extension ContactFormTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            phoneNumberTextField.becomeFirstResponder()
        } else if textField == phoneNumberTextField {
            address1TextField.becomeFirstResponder()
        } else if textField == address1TextField {
            address2TextField.becomeFirstResponder()
        } else if textField == address2TextField {
            cityTextField.becomeFirstResponder()
        } else if textField == cityTextField {
            stateTextField.becomeFirstResponder()
        } else if textField == stateTextField {
            zipcodeTextField.becomeFirstResponder()
        } else if textField == zipcodeTextField {
            view.endEditing(true)
        }
        return true
    }
}

extension ContactFormTableViewController {
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height - navBarHeight, 0.0)
        
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        aRect.size.height -= navBarHeight
        guard let activeTextField = activeTextField,
            !aRect.contains(activeTextField.frame.origin) else  { return }
        tableView.scrollRectToVisible(activeTextField.frame, animated: true)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
}
