//
//  ViewController.swift
//  phone
//
//  Created by Aliya Dekelbayeva on 15.11.2023.
//

import UIKit

class ViewController: UIViewController, ContactViewControllerDelegate {
    func contactWasDeleted() {
        reloadDataSource()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func segmentedControlValueChange(_ sender: Any) {
        reloadDataSource()
    }
    
    
    var arrayOfContactGroup: [ContactGroup] = [] {

        didSet {
            tableView.reloadData()
        }
    }
    let helper = ContactHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: ContactTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.addTarget(self, action: #selector(reloadDataSource), for: .valueChanged)
        
        reloadDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        fillInfo()
    }
    
    let allContactsKey: String = "allContactsKey"
    
    func fillInfo() {
        let alertController = UIAlertController(title: "Add contact", message: nil, preferredStyle: .alert)
        print(helper.getAllContacts())

        alertController.addTextField { textField in
            textField.placeholder = "Enter your First name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter your Last name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter your telephone number"
        }
        
        let showModal = UIAlertAction(title: "Add", style: .default){
            _ in
                guard let firstName: String = alertController.textFields![0].text, !firstName.isEmpty else {
                    self.showErrorMessage(message: "First name is empty")
                    return
                }
                guard let lastName: String = alertController.textFields![1].text, !lastName.isEmpty else {
                    self.showErrorMessage(message: "Last name is empty")
                    return
                }
                guard let phone: String = alertController.textFields![2].text, !phone.isEmpty else {
                    self.showErrorMessage(message: "Phone is empty")
                    return
                }

                
            let contact = Contact(firstName: firstName, lastName: lastName, phone: phone)
            self.add(contact: contact)
        }
        
        alertController.addAction(showModal)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        }
    
    func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: "Error:", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    @objc
    func reloadDataSource() {
        tableView.refreshControl!.beginRefreshing()

        let allContacts = helper.getAllContacts()
        var groups = [String: [Contact]]()
        
        switch segmentedControl.selectedSegmentIndex {
            case 0:
            groups = Dictionary(grouping: allContacts, by: { String($0.firstName.prefix(1)).uppercased() })
            case 1:
            groups = Dictionary(grouping: allContacts, by: { String($0.lastName.prefix(1)).uppercased() })
            default:
                break
            }
        let contactGroups = groups.map { character, contact -> ContactGroup in
            ContactGroup(title: character,contacts: contact)
        }.sorted(by: {$0.title < $1.title})
        
        tableView.refreshControl!.endRefreshing()
        self.arrayOfContactGroup = contactGroups
    }
    
    func deleteContact(indexPath: IndexPath) {
        let deletedContact = arrayOfContactGroup[indexPath.section].contacts.remove(at: indexPath.row)
        if arrayOfContactGroup[indexPath.section].contacts.count < 1 {
            arrayOfContactGroup.remove(at: indexPath.section)
        }
        
        helper.delete(contactToDelete: deletedContact)
    }
    
    func add(contact: Contact) {
        helper.add(contact: contact)
        self.reloadDataSource()
    }
    
    func getContact(indexPath: IndexPath) -> Contact {
        let contactGroup = arrayOfContactGroup[indexPath.section]
        let contact = contactGroup.contacts[indexPath.row]
        return contact
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfContactGroup.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfContactGroup[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        let contact = getContact(indexPath: indexPath)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.contactTableViewCell.text = "\(contact.firstName) \(contact.lastName)"
        }else if segmentedControl.selectedSegmentIndex == 1 {
            cell.contactTableViewCell.text = "\(contact.lastName) \(contact.firstName)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrayOfContactGroup[section].title
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteContact(indexPath: indexPath)
        }
    }
}

// Расширение для ViewController и подписка на протокол UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let contact = getContact(indexPath: indexPath)
        let contactViewController = ContactViewController()
        contactViewController.contact = contact
        contactViewController.delegate = self
        navigationController?.pushViewController(contactViewController, animated: true)
    }
}
    

