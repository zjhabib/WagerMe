//
//  ImportContactsViewController.swift
//
//
//  Created by steven poulos on 4/18/17.
//CODED BY STEVEN POULOS
//FOLLOWED TUTORIAL FROM APP FOUNDATION
//Address Book Tutorial in Swift and iOS. (n.d.). Retrieved April 20, 2017,
//  from https://www.raywenderlich.com/97936/address-book-tutorial-swift-ios

import UIKit
import Contacts
import ContactsUI

class ImportContactsViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var store = CNContactStore()
    var contacts: [CNContact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func ValueChanged(_ sender: AnyObject) {
        if let query = textField.text {
            findContacts(query)
        }
    }
    
    
    
    func findContacts(_ name: String) {
        
        AppDelegate.sharedDelegate().checkAccessStatus({ (accessGranted) -> Void in
            if accessGranted {
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: name)
                        
                        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey,
                                           CNContactViewController.descriptorForRequiredKeys()] as [Any]
                        
                        self.contacts = try self.store.unifiedContacts(matching: predicate, keysToFetch:keysToFetch as! [CNKeyDescriptor])
                        self.tableView.reloadData()
                    }
                    catch {
                        print("Unable to refetch.")
                    }
                }
                )
                
            }
            
            
        })
    }
    
}



extension ImportContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let CellIdentifier = "MyCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        cell!.textLabel!.text = contacts[indexPath.row].givenName + " " + contacts[indexPath.row].familyName
        
        return cell!
    }
    
}



extension ImportContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let controller = CNContactViewController(for: contacts[indexPath.row])
        controller.contactStore = self.store
        controller.allowsEditing = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

