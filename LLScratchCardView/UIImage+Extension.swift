//
//  UIImage+Extension.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 23/12/2019.
//  Copyright © 2019 Focus. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func imageWithColorSize(color: UIColor, size: CGSize) -> UIImage{
        return UIGraphicsImageRenderer(size: size).image { _ in
            color.setFill()
            UIRectFill(CGRect.init(origin: CGPoint.zero, size: size))
        }
    }
    
    func crop(toRect rect:CGRect) -> UIImage? {
        if rect.origin == CGPoint.zero && self.size == rect.size {
            return self
        }
        guard let imageRef = self.cgImage?.cropping(to: rect) else { return self }
        return UIImage.init(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
    }
}

