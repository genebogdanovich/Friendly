//
//  MasterViewController.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 28.12.20.
//

import UIKit
import Firebase

private let cellID = "ITEM_CELL"

class MasterViewController: UITableViewController {
    
    weak var delegate: ItemSelectionDelegate?
    var contacts = [Contact]()
    
    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellID)
        configureBarButtonItems()
        
        // Show login screen if the user is not logged in.
        if Auth.auth().currentUser == nil {
            print("User is not logged in.")
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        } else {
            print("User is logged in.")
        }
        
        fetchContacts()
        
    }
    
    fileprivate func configureBarButtonItems() {
        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(handleMore))
        self.navigationItem.leftBarButtonItem = moreButton
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleInsertNewObject))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func handleInsertNewObject() {
        let newContactController = NewContactController()
        let navController = UINavigationController(rootViewController: newContactController)
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Handle user actions
    
    @objc fileprivate func handleMore() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { _ in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            } catch let signoutError {
                print("Failed to sign out: \(signoutError)")
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Setting up layout
    
    fileprivate func configureLayout() {
        // Setting up layout
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
        cell.contact = contacts[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            
        } else if editingStyle == .insert {
            
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Call delegate and pass the item
        
        if let detailViewController = delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    // MARK: - Networking
    
    fileprivate func fetchContacts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database
            .database(url: MyFirebaseCredentials.realtimeDatabaseURLString)
            .reference()
            .child("contacts")
            .child(uid)
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                dictionaries.forEach { key, value in
                    guard let dictionary = value as? [String: Any] else { return }
                    let contact = Contact(dictionary: dictionary)
                    self.contacts.append(contact)
                }
                self.tableView.reloadData()
            }, withCancel: { error in
                print("Failed to fetch posts: \(error)")
            })
        
    }

}

protocol ItemSelectionDelegate: class {
    func itemSelected(_ newItem: Date)
}
