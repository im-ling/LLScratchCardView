//
//  UIButton+Extension.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 14/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

extension UIButton{
    convenience init(backGroundImageName:String,title:String,target:Any?,action:Selector,layerCornerRadius:CGFloat){
        self.init()
        setBackgroundImage(UIImage(named:backGroundImageName), for: .normal)
        setTitle(title, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
        if layerCornerRadius != 0 {
            layer.cornerRadius = layerCornerRadius
            layer.masksToBounds = true
        }
    }
}

extension UIButton{
    convenience init(title:String,target:Any?,action:Selector){
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(.blue, for: .normal)
        addTarget(target, action:action, for: .touchUpInside)
        sizeToFit()
    }
}
