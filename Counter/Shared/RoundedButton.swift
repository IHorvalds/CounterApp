//
//  RoundedButton.swift
//  Counter
//
//  Created by Tudor Croitoru on 21/04/2019.
//  Copyright © 2019 Tudor Croitoru. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {
    
    @IBInspectable var backCol: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) {
        didSet {
            backgroundColor = backCol
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 15.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius  = cornerRadius
        backgroundColor     = backCol
        
        let font                = UIFont(name: "Roboto Thin", size: 17.0)
        titleLabel?.font        = font
        titleLabel?.textColor   = .white
    }

}
