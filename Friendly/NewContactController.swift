//
//  NewContactController.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 29.12.20.
//

import UIKit
import Firebase

class NewContactController: UIViewController {
    
    // MARK: - Views
    let addPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        
        return button
    }()
    
    let firstNameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "First name"
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.03)
        view.borderStyle = .roundedRect
        view.font = UIFont.systemFont(ofSize: 14)
        
        return view
    }()
    
    let lastNameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Last name"
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.03)
        view.borderStyle = .roundedRect
        view.font = UIFont.systemFont(ofSize: 14)
        
        return view
    }()
    
    let emailTextField: UITextField = {
        let view = UITextField()
        view.autocapitalizationType = .none
        view.placeholder = "Email"
        view.keyboardType = .emailAddress
        view.backgroundColor = UIColor(white: 0, alpha: 0.03)
        view.borderStyle = .roundedRect
        view.font = UIFont.systemFont(ofSize: 14)
        
        return view
    }()
    
    let phoneNumberTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Phone"
        view.keyboardType = .phonePad
        view.backgroundColor = UIColor(white: 0, alpha: 0.03)
        view.borderStyle = .roundedRect
        view.font = UIFont.systemFont(ofSize: 14)
        
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "New Contact"
        configureBarButtonItems()
        configureLayout()
        
    }
    
    // MARK: - Setting up layout
    
    fileprivate func configureLayout() {
        view.addSubview(addPhotoButton)
        
        addPhotoButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            right: nil,
            bottom: nil,
            left: nil,
            paddingTop: 20,
            paddingRight: 0,
            paddingBottom: 0,
            paddingLeft: 0,
            width: 140,
            height: 140
        )
        
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
            firstNameTextField,
            lastNameTextField,
            phoneNumberTextField,
            emailTextField,
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        stackView.anchor(
            top: addPhotoButton.bottomAnchor,
            right: view.rightAnchor,
            bottom: nil,
            left: view.leftAnchor,
            paddingTop: 40,
            paddingRight: 5,
            paddingBottom: 0,
            paddingLeft: 5,
            width: 0,
            height: 190
        )
    }
    
    fileprivate func configureBarButtonItems() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Handling user actions
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc fileprivate func handleDone() {
        guard let firstName = firstNameTextField.text, firstName.count > 0 else { return }
        guard let lastName = lastNameTextField.text, lastName.count > 0 else { return }
        guard let emailAddress = emailTextField.text, emailAddress.count > 0 else { return }
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber.count > 0 else { return }
        
        guard let image = addPhotoButton.imageView?.image else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
        let imageFileName = UUID().uuidString
        
        // Root reference
        let storageReference = Storage.storage().reference()
        // Reference to file
        let imageReference = storageReference.child("contact_avatars").child(imageFileName)
        
        imageReference.putData(uploadData, metadata: nil, completion: { metadata, error in
            if let error = error {
                print("Failed to upload contact avatar: \(error)")
            }
            
            imageReference.downloadURL(completion: { url, error in
                guard let downloadURL = url else { return }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let values = [
                    "firstName": firstName,
                    "lastName": lastName,
                    "emailAddress": emailAddress,
                    "phoneNumber": phoneNumber,
                    "avatarURL": downloadURL.absoluteString,
                    "avatarImageWidth": image.size.width,
                    "avatarImageHeight": image.size.height,
                    "creationDate": Date().timeIntervalSince1970,
                    
                ] as [String: Any]
                
                let contactReference = Database
                    .database(url: FirebaseAPICredentials.dbURLString)
                    .reference()
                    .child("contacts")
                    .child(uid)
                
                let reference = contactReference.childByAutoId()
                
                reference.updateChildValues(values) { error, reference in
                    if let error = error {
                        print("Failed to save contact to DB: \(error)")
                        return
                    }
                    print("Successfully saved contact to DB.")
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                
            })
            
        })
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleAddPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }

}

// MARK: - UIImagePickerControllerDelegate

extension NewContactController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            addPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            addPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
}
