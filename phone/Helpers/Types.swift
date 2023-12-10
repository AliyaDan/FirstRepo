import Foundation

struct Contact: Codable {
    let firstName: String
    let lastName: String
    let phone: String
}

struct ContactGroup {
    let title: String
    var contacts: [Contact]
}

enum ContactType {
    case message
    case call
    case faceTime
    
    var urlScheme: String {
        switch self {
        case .message:
            return "sms://"
        case .call:
            return "tel://"
        case .faceTime:
            return "facetime://"
        }
    }
}
