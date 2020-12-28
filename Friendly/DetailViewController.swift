//
//  DetailViewController.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 28.12.20.
//

import UIKit

class DetailViewController: UIViewController {
    var detailItem: Date? {
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
        view.backgroundColor = .white
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
            detailDescriptionLabel.text = detail.description
        }
    }
}

extension DetailViewController: ItemSelectionDelegate {
    func itemSelected(_ newItem: Date) {
        detailItem = newItem
    }
}
