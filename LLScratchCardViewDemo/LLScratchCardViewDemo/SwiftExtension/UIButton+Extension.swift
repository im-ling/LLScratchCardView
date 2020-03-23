//
//  UIButton+Extension.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 14/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

extension UIButton{
    class func ll_button(backGroundImageName: String, title: String, target: Any?, action: Selector, layerCornerRadius: CGFloat) -> UIButton {
        return ll_button_full_parameters(title: title, target: target, action: action, color: nil, layerCornerRadius: layerCornerRadius, backGroundImageName: backGroundImageName)
    }
    
    class func ll_button(title: String, target: Any?, action: Selector) -> UIButton {
        return ll_button_full_parameters(title: title, target: target, action: action, color: nil, layerCornerRadius: nil, backGroundImageName: nil)
    }
    
    class func ll_button(title: String, target: Any?, action: Selector, color: UIColor) -> UIButton {
        return ll_button_full_parameters(title: title, target: target, action: action, color: color, layerCornerRadius: nil, backGroundImageName: nil)
    }

    
    class func ll_button_full_parameters(title: String?, target: Any?, action: Selector, color: UIColor?, layerCornerRadius: CGFloat?, backGroundImageName:String?) -> UIButton {
        let button = UIButton.init()
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        if layerCornerRadius != nil {
            button.layer.cornerRadius = layerCornerRadius!
            button.layer.masksToBounds = true
        }
        if backGroundImageName != nil {
            button.setBackgroundImage(UIImage.init(named: backGroundImageName!), for: .normal)
        }
        button.sizeToFit()
        return button
    }

}

extension UIButton{
    convenience init(title:String,target:Any?,action:Selector){
        self.init()
        setTitle(title, for: .normal)
        addTarget(target, action:action, for: .touchUpInside)
        sizeToFit()
    }
}
