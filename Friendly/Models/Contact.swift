//
//  Contact.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 29.12.20.
//

import Foundation

struct Contact {
    let firstName: String
    let lastName: String
    let emailAddress: String
    let phoneNumber: String
    let avatarURL: String
    let uid: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.emailAddress = dictionary["emailAddress"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.avatarURL = dictionary["avatarURL"] as? String ?? ""
        
        self.uid = uid
    }
    
    
}

extension Contact: Equatable {
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.uid == rhs.uid
    }
}
