//
//  UIViewController+.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 29.12.20.
//

import UIKit

extension UIViewController {
    func showBasicAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
