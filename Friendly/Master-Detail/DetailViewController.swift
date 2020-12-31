//
//  DetailViewController.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 28.12.20.
//

import UIKit
import SwiftUI

class DetailViewController: UIViewController {
    var detailItem: Contact? {
        didSet {
            updateUI()
        }
    }
    
    let detailDescriptionLabel: UILabel = {
        let view = UILabel()
        
        view.text = ""
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLayout()
        updateUI()
    }
    
    fileprivate func configureLayout() {
        view.addSubview(detailDescriptionLabel)
        detailDescriptionLabel.center(in: view)
    }
    
    fileprivate func updateUI() {
        if let detail = detailItem {
            print("Updating UI.")
            detailDescriptionLabel.text = detail.lastName
        }
    }
}

extension DetailViewController: MasterViewControllerDelegate {
    
    func masterViewController(didSelectContact contact: Contact) {
        detailItem = contact
    }
}
