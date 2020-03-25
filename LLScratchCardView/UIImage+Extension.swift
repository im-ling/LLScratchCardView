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
        let blurFilter = CIFilter(name: "CIBoxBlur")
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
    
    func ll_pixelImage(level: Int) -> UIImage? {
        let image = self
        
        guard let inputCGImage = image.cgImage else {
            print("ll_pixelImage unable to get cgImage")
            return self
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo

        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("ll_pixelImage unable to create context")
            return self
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let buffer = context.data else {
            print("ll_pixelImage unable to get context data")
            return self
        }
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        var pixel:RGBA32 = RGBA32.init(red: 0, green: 0, blue: 0, alpha: 0)
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if row % level == 0 {
                    if column % level == 0 {
                        pixel = pixelBuffer[offset]
                    }else{
                        pixelBuffer[offset] = pixel
                    }
                }else{
                    pixelBuffer[offset] = pixelBuffer[offset - width]
                }
            }
        }

        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        return outputImage
    }
}


struct RGBA32: Equatable {
    private var color: UInt32

    var redComponent: UInt8 {
        return UInt8((color >> 24) & 255)
    }

    var greenComponent: UInt8 {
        return UInt8((color >> 16) & 255)
    }

    var blueComponent: UInt8 {
        return UInt8((color >> 8) & 255)
    }

    var alphaComponent: UInt8 {
        return UInt8((color >> 0) & 255)
    }

    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        let red   = UInt32(red)
        let green = UInt32(green)
        let blue  = UInt32(blue)
        let alpha = UInt32(alpha)
        color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
    }

    static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
    static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
    static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
    static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
    static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
    static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
    static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
    static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)

    static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

    static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
        return lhs.color == rhs.color
    }
}


