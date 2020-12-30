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
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
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
            top: nil,
            right: nil,
            bottom: nil,
            left: leftAnchor,
            paddingTop: 0,
            paddingRight: 0,
            paddingBottom: 0,
            paddingLeft: 10,
            width: 64,
            height: 64
        )
        
        contactImageView.layer.cornerRadius = 64 / 2
        contactImageView.layer.masksToBounds = true
        contactImageView.layer.borderWidth = 1
        contactImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
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
    
    fileprivate func setupAttributedLabel() {
        guard let firstName = contact?.firstName else { return }
        guard let lastName = contact?.lastName else { return }
        
        let attributedText = NSMutableAttributedString(string: "\(firstName) ", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.labelFontSize)
        ])
        
        attributedText.append(NSMutableAttributedString(string: lastName, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        ]))
        
        self.contactNameLabel.attributedText = attributedText
    }
}
