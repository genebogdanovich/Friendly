//
//  Storage+.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 31.12.20.
//

import Foundation
import Firebase

extension Storage {
    static func saveContactAvatarToStorage(image: UIImage, completion: @escaping (URL?, Error?) -> Void) {
        guard let uploadData = image.jpegData(compressionQuality: 0.1) else { return }
        let imageFileName = UUID().uuidString
        
        let imageReference = Storage
            .storage()
            .reference()
            .child("contact_avatars")
            .child(imageFileName)
        
        imageReference.putData(uploadData, metadata: nil, completion: { metadata, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            imageReference.downloadURL(completion: { url, error in
                
                completion(url, nil)
                return
            })
        })
    }
}

