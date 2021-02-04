//
//  MasterViewController.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 28.12.20.
//

import UIKit
import Firebase
import Combine

private let cellID = "CELL_ID"

class MasterViewController: UITableViewController {
    
    weak var delegate: MasterViewControllerDelegate?
    var contacts = [Contact]()
    var filteredContacts = [Contact]()
    var subscriptions = Set<AnyCancellable>()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: - UISearchController
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellID)
        // Removes extra lines on the bottom.
        tableView.tableFooterView = UIView()
        
        configureBarButtonItems()
        
        // Show login screen if the user is not logged in.
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        fetchFutureContacts()
        
        // UISearchController
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        // By setting definesPresentationContext on your view controller to true, you ensure that the search bar doesn’t remain on the screen if the user navigates to another view controller while the UISearchController is active.
        definesPresentationContext = true
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
                print("Failed to sign out: \(signoutError).")
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleInsertNewObject() {
        let newContactController = NewContactController()
        newContactController.delegate = self
        let navController = UINavigationController(rootViewController: newContactController)
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Setting up layout
    
    fileprivate func configureLayout() {
        // Setting up layout
    }
    
    fileprivate func configureBarButtonItems() {
        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(handleMore))
        self.navigationItem.leftBarButtonItem = moreButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleInsertNewObject))
        self.navigationItem.rightBarButtonItem = addButton
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredContacts.count
        } else {
            return contacts.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
        let contact: Contact
        
        if isFiltering {
            contact = filteredContacts[indexPath.row]
        } else {
            contact = contacts[indexPath.row]
        }
        
        cell.contact = contact
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contactToDelete = contacts[indexPath.row]
            
            Database.removeContact(contactToDelete, completion: { error in
                if let error = error {
                    print("Failed to remove contact from database: \(error).")
                    return
                }
                print("Successfully removed contact from database.")
                self.contacts = self.contacts.filter { $0 != contactToDelete }
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            })
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact: Contact
        
        if isFiltering {
            contact = filteredContacts[indexPath.row]
        } else {
            contact = contacts[indexPath.row]
        }
        
        delegate?.masterViewController(didSelectContact: contact)
        
        if let detailViewController = delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Networking
    
    
    fileprivate func fetchFutureContacts() {
        let future = Database.fetchContactsFuture()
        
        future.sink { (completion) in
            print(completion)
            
            switch completion {
            case .failure(let error):
                print("Failed to fetch contacts: \(error).")
                self.showBasicAlert(withTitle: "Failed to fetch contacts", message: error.localizedDescription)
            case .finished:
                print("Finished")
            }
        } receiveValue: { (dictionaries) in
            dictionaries.forEach { key, value in
                guard let dictionary = value as? [String: Any] else { return }
                
                let contact = Contact(uid: key, dictionary: dictionary)
                self.contacts.append(contact)
            }
            self.contacts.sort(by: { contact1, contact2 in
                return contact1.lastName.compare(contact2.lastName) == .orderedAscending
            })
            self.tableView.reloadData()
        }
        .store(in: &subscriptions)
    }
    
    
//    fileprivate func fetchContacts() {
//        Database.fetchContacts { dictionaries, error in
//            if let error = error {
//                print("Failed to fetch contacts: \(error).")
//                self.showBasicAlert(withTitle: "Failed to fetch contacts", message: error.localizedDescription)
//            }
//
//            guard let dictionaries = dictionaries else { return }
//
//            dictionaries.forEach { key, value in
//                guard let dictionary = value as? [String: Any] else { return }
//
//                let contact = Contact(uid: key, dictionary: dictionary)
//                self.contacts.append(contact)
//            }
//            self.contacts.sort(by: { contact1, contact2 in
//                return contact1.lastName.compare(contact2.lastName) == .orderedAscending
//            })
//            self.tableView.reloadData()
//        }
//    }
    
    // MARK: - Filtering
    fileprivate func filterContentForSearchText(_ searchText: String) {
        filteredContacts = contacts.filter { (contact: Contact) -> Bool in
            return contact.fullName.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}

// MARK: - MasterViewControllerDelegate

protocol MasterViewControllerDelegate: class {
    func masterViewController(didSelectContact contact: Contact)
}

extension MasterViewController: NewContactControllerDelegate {
    func newContactController(didAddNewContact contact: Contact) {
        
        contacts.append(contact)
        
        self.contacts.sort(by: { contact1, contact2 in
            return contact1.lastName.compare(contact2.lastName) == .orderedAscending
        })
        
        tableView.beginUpdates()
        
        if let index = contacts.firstIndex(of: contact) {
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        } else {
            tableView.reloadData()
        }
        
        tableView.endUpdates()
    }
}

// MARK: - UISearchResultsUpdating

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
