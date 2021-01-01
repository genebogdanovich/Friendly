//
//  Database+.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 29.12.20.
//

import Foundation
import Firebase

extension Database {
    static func saveContactInfoToDatabase(info: [String: Any], completion: @escaping (DatabaseReference?, Error?) -> Void) {
        guard let currentLoggedInUserID = Auth.auth().currentUser?.uid else { return }
        
        let contactReference = Database
            .database(url: MyFirebaseCredentials.realtimeDatabaseURLString)
            .reference()
            .child("contacts")
            .child(currentLoggedInUserID)
            .childByAutoId()
        
        contactReference.updateChildValues(info) { error, reference in
            if let error = error {
                completion(nil, error)
                return
            }
            
            completion(reference, nil)
            return
            
        }
    }
    
    static func saveContactToDatabase(contact: Contact, completion: @escaping (Error?) -> Void) {
        // Implement this method to get the dictionary out of the NewContactController.
    }
    
    static func removeContactFromDatabase(contact: Contact, completion: @escaping (Error?) -> Void) {
        guard let currentLoggedInUserID = Auth.auth().currentUser?.uid else { return }
        
        Database
            .database(url: MyFirebaseCredentials.realtimeDatabaseURLString)
            .reference()
            .child("contacts")
            .child(currentLoggedInUserID)
            .child(contact.uid)
            .removeValue(completionBlock: { error, reference in
                if let error = error {
                    completion(error)
                    return
                }
            })
        completion(nil)
        return
        
        // FIXME: Remove image!
    }
    
    static func fetchContacts(completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let currentLoggedInUserID = Auth.auth().currentUser?.uid else { return }
        
        Database
            .database(url: MyFirebaseCredentials.realtimeDatabaseURLString)
            .reference()
            .child("contacts")
            .child(currentLoggedInUserID)
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                completion(dictionaries, nil)
                return
                
            }, withCancel: { error in
                
                
                completion(nil, error)
                return
                
            })
    }
}
