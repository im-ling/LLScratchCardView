//
//  UIView+Extension.swift
//  Swift_Microblogging
//
//  Created by NowOrNever on 26/03/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit

extension UIView{
    var x:CGFloat{
        get{
            return frame.origin.x
        }
        set{
            frame.origin.x = newValue
        }
    }
    var y:CGFloat{
        get{
            return frame.origin.y
        }
        set{
            frame.origin.y = newValue
        }
    }
    
    var centerX:CGFloat{
        get{
            return center.x
        }
        set{
            center.x = newValue
        }
    }
    
    var centerY:CGFloat{
        get{
            return center.y
        }
        set{
            center.y = newValue
        }
    }
    
    var width:CGFloat{
        get{
            return bounds.size.width
        }
        set{
            bounds.size.width = newValue
        }
    }
    
    var height:CGFloat{
        get{
            return bounds.size.height
        }
        set{
            bounds.size.height = newValue
        }
    }
    
    var size:CGSize{
        get{
            return bounds.size
        }
        set{
            bounds.size = newValue
        }
    }
}


