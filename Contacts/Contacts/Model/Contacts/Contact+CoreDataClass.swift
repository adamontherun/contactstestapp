import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {}

extension Contact {
    var displayName: String {
        if let firstName = firstName, let lastName = lastName {
            return firstName + " " + lastName
        } else if let firstName = firstName {
            return firstName
        } else if let lastName = lastName {
            return lastName
        } else if let phoneNumber = phoneNumber {
            return phoneNumber
        } else {
            return "NA"
        }
    }
}
