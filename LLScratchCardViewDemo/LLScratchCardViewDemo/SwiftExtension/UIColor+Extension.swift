//
//  UIColor+Extension.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 21/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

extension UIColor{
    class func colorWithHex(hex:Int) ->UIColor {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF;
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1);
    }
    
    class func randomColor() -> UIColor{
        return UIColor(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1)
    }
}
