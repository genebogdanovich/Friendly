//
//  UIView+.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 28.12.20.
//

import UIKit

extension UIView {
    func anchor(
        top: NSLayoutYAxisAnchor?,
        right: NSLayoutXAxisAnchor?,
        bottom: NSLayoutYAxisAnchor?,
        left: NSLayoutXAxisAnchor?,
        paddingTop: CGFloat,
        paddingRight: CGFloat,
        paddingBottom: CGFloat,
        paddingLeft: CGFloat,
        width: CGFloat,
        height: CGFloat
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top { topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true }
        
        if let left = left { leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true }
        
        if let bottom = bottom { bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true }
        
        if let right = right { rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true }
        
        if width != 0 { widthAnchor.constraint(equalToConstant: width).isActive = true }
        
        if height != 0 { heightAnchor.constraint(equalToConstant: height).isActive = true }
    }
    
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
    
    func center(in superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
    }
}


