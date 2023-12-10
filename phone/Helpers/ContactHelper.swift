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
        // Извлекаются все контакты
        var allContacts = getAllContacts()
        
        // Пробегаемся по каждому контакту
        for index in 0..<allContacts.count {
            // извлекаемся контакт по индексу
            let contact = allContacts[index]
            
            //Сверяем данные контакта
            if contact.firstName == contactToEdit.firstName && contact.lastName == contactToEdit.lastName && contact.phone == contactToEdit.phone {
                // Если они одинаковые то срабатывает данный блок кода
                
                // Удаляем из массива allContacts старый контакт по индексу
                allContacts.remove(at: index)
                // Добавляем новый, отредактрованный контакт в массив под индексом
                allContacts.insert(editedContact, at: index)
                
                // ключевое слово break выводит чтение кода из цикла. Почему именно здесь? Потому что здесь мы уже нашли нужный нам контакт и заменили на новый, и дальше нет смысла пробегаться по остальным контактам в массиве allContacts.
                break
            }
        }
        
        // Перезаписываемся список контактов в базу данных
        save(allContacts: allContacts)
    }
    
    func delete(contactToDelete: Contact) {
        // Извлекаются все контакты
        var allContacts = getAllContacts()
        
        // Пробегается по каждому контакту в allContacts
        for index in 0..<allContacts.count {
            
            // Извлечение контакта
            let contact = allContacts[index]
            
            //Сверяем данные контакта
            if contact.firstName == contactToDelete.firstName && contact.lastName == contactToDelete.lastName && contact.phone == contactToDelete.phone {
                // Если они одинаковые то срабатывает данный блок кода
                
                // Удаляется контакт с индексом
                allContacts.remove(at: index)
                
                // ключевое слово break выводит чтение кода из цикла. Почему именно здесь? Потому что здесь мы уже нашли нужный нам контакт и заменили на новый, и дальше нет смысла пробегаться по остальным контактам в массиве allContacts.
                break
            }
        }
        
        save(allContacts: allContacts)
    }
}
