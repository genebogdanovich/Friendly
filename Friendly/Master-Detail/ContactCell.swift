//
//  ContactCell.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 29.12.20.
//

import UIKit

class ContactCell: UITableViewCell {
    
    var contact: Contact? {
        didSet {
            guard let avatarURL = contact?.avatarURL else { return }
            contactImageView.loadImage(urlString: avatarURL)
            setupAttributedLabel()
        }
    }
    
    // MARK: - Views
    
    var contactImageView: RemoteImageView = {
        let view = RemoteImageView()
        
        return view
    }()
    var contactNameLabel: UILabel = {
        let label = UILabel()
        
        
        return label
    }()
    
    // MARK: - Inits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting up layout
    
    fileprivate func configureLayout() {
        addSubview(contactImageView)
        
        contactImageView.anchor(
            top: topAnchor,
            right: nil,
            bottom: bottomAnchor,
            left: leftAnchor,
            paddingTop: 10,
            paddingRight: 0,
            paddingBottom: 10,
            paddingLeft: 10,
            width: 64,
            height: 64
        )
        
        addSubview(contactNameLabel)
        
        contactNameLabel.anchor(
            top: topAnchor,
            right: rightAnchor,
            bottom: bottomAnchor,
            left: contactImageView.rightAnchor,
            paddingTop: 0,
            paddingRight: 0,
            paddingBottom: 0,
            paddingLeft: 10,
            width: 0,
            height: 0)
    }
    
    // MARK: -- Setting up data
    
    fileprivate func setupAttributedLabel() {
        guard let firstName = contact?.firstName else { return }
        guard let lastName = contact?.lastName else { return }
        
        let attributedText = NSMutableAttributedString(string: "\(firstName) ", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
        ])
        
        attributedText.append(NSMutableAttributedString(string: lastName, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)
        ]))
        
        self.contactNameLabel.attributedText = attributedText
    }
}
