//
//  Themes.swift
//  Counter
//
//  Created by Tudor Croitoru on 22/04/2019.
//  Copyright © 2019 Tudor Croitoru. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    
    enum theme: Int {
        
        case light  = 0
        case dark   = 1
    }
    
    static func labelColour(theme: theme) -> UIColor {
        if theme == .light {
            return UIColor.lightGray
        } else {
            return UIColor.gray
        }
    }
    
    static func counterColours(theme: theme) -> [UIColor] {
        if theme == .light {
            return [#colorLiteral(red: 0.2961215102, green: 0.01937576197, blue: 0, alpha: 1), UIColor.darkGray]
        } else {
            return [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), UIColor.lightGray]
        }
    }
    
    static func backgroundColour(theme: theme) -> UIColor {
        if theme == .light {
            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            return #colorLiteral(red: 0.1573405774, green: 0.1480556627, blue: 0.1419859072, alpha: 1)
        }
    }
    
    static func groupedTableViewBackground(theme: theme) -> UIColor {
        if theme == .light {
            return .groupTableViewBackground
        } else {
            return #colorLiteral(red: 0.3892766497, green: 0.3892766497, blue: 0.3892766497, alpha: 1)
        }
    }
    
    static func navBarColor(theme: theme) -> UIBarStyle {
        if theme == .light {
            return .default
        } else {
            return .blackTranslucent
        }
    }
    
    static func buttonColor(theme: theme) -> UIColor {
        if theme == .light {
            return UIColor(red: 21/255, green: 125/255, blue: 249/255, alpha: 1)
        }
        
        return UIColor(red: 238/255, green: 153/255, blue: 66/255, alpha: 1)
    }
    
}
