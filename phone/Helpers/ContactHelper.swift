//
//  ContactHelper.swift
//  phone
//
//  Created by Aliya Dekelbayeva on 07.12.2023.
//

import Foundation

struct ContactHelper {
    let allContactsKey: String = "allContactsKey"
    let userDefaults: UserDefaults = UserDefaults.standard
    
    func getAllContacts() -> [Contact] {
        var allContacts: [Contact] = []
        
        if let data = UserDefaults.standard.object(forKey: allContactsKey) as? Data {
            do {
                let decoder = JSONDecoder()
                allContacts = try decoder.decode([Contact].self, from: data)
                
            } catch {
                print("could'n decode given data to [Contact] with error: \(error.localizedDescription)")
            }
        }
        
        return allContacts
    }
    
    func add(contact: Contact) {
        var allContacts = getAllContacts()
        allContacts.append(contact)
        
        save(allContacts: allContacts)
    }

    func save(allContacts: [Contact]) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(allContacts)
            UserDefaults.standard.set(encodedData, forKey: allContactsKey)
        } catch {
            print("Couldn't encode given [Userscore] into data with error: \(error.localizedDescription)")
        }
    }
    
    func edit(contactToEdit: Contact, editedContact: Contact) {
        var allContacts = getAllContacts()
        
        for index in 0..<allContacts.count {
            let contact = allContacts[index]
            
            if contact.firstName == contactToEdit.firstName && contact.lastName == contactToEdit.lastName && contact.phone == contactToEdit.phone {
                allContacts.remove(at: index)
                allContacts.insert(editedContact, at: index)
                
                break
            }
        }
        
        save(allContacts: allContacts)
    }
    
    func delete(contactToDelete: Contact) {
        var allContacts = getAllContacts()
        
        for index in 0..<allContacts.count {
            let contact = allContacts[index]

            if contact.firstName == contactToDelete.firstName && contact.lastName == contactToDelete.lastName && contact.phone == contactToDelete.phone {
                allContacts.remove(at: index)

                break
            }
        }
        
        save(allContacts: allContacts)
    }
}
