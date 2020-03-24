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

    func ll_getAspectFillImage(imageViewSize: CGSize?) -> UIImage? {
        guard let imageViewSize = imageViewSize else { return self }
        var size = self.size
        if size.width < imageViewSize.width || size.height < imageViewSize.height {
            size = size.ll_aspectExtend(to: imageViewSize)
        }
        let rect = size.ll_getRectAfterCropToSize(to: imageViewSize)
        return self.crop(toRect: rect)
    }

    func crop(toRect rect:CGRect) -> UIImage? {
        if rect.origin == CGPoint.zero && self.size == rect.size {
            return self
        }
        guard let imageRef = self.cgImage?.cropping(to: rect) else { return self }
        return UIImage.init(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
    }
    
    func blurImage(blurAmount: CGFloat) -> UIImage? {
        guard let ciImage = CIImage.init(image: self) else { return self }
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        guard let outputImage = blurFilter?.outputImage else { return self }
        return UIImage.init(ciImage: outputImage)
    }
    
    func pixelImage(level: CGFloat) -> UIImage? {
        guard let ciImage = CIImage.init(image: self) else { return self }
        let pixellateFilter = CIFilter(name: "CIPixellate")
        pixellateFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        pixellateFilter?.setValue(level, forKey: kCIInputScaleKey)
        guard let outputImage = pixellateFilter?.outputImage else { return self }
        return UIImage.init(ciImage: outputImage)
    }
}

