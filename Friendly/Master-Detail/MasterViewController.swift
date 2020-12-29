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
    var dates = [Date]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
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
        
    }
    
    fileprivate func configureBarButtonItems() {
        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(handleMore))
        self.navigationItem.leftBarButtonItem = moreButton
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleInsertNewObject))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func handleInsertNewObject() {
        dates.insert(Date(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
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
        
        return dates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let date = dates[indexPath.row]
        cell.textLabel?.text = date.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dates.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            (delegate as? DetailViewController)?.detailItem = nil
        } else if editingStyle == .insert {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = dates[indexPath.row]
        delegate?.itemSelected(selectedItem)
        
        if let detailViewController = delegate as? DetailViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }

}

protocol ItemSelectionDelegate: class {
    func itemSelected(_ newItem: Date)
}
