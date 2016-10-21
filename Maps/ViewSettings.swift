//
//  ViewSettings.swift
//  Maps
//
//  Created by Kevin Dang on 10/15/16.
//  Copyright © 2016 Team_Interactive_Maps. All rights reserved.
//
import UIKit

@IBDesignable
class ViewSettings: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
