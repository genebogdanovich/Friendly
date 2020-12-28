//
//  UIColor+.swift
//  Friendly
//
//  Created by Gene Bogdanovich on 28.12.20.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
