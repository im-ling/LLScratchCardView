//
//  LLScratchCardView.swift
//  LLScratchCardViewDemo
//
//  Created by NowOrNever on 22/03/2020.
//  Copyright © 2020 LL. All rights reserved.
//

import UIKit

class LLScratchCardView: UIView {
    var lineWidth: CGFloat = 40.0 {
        didSet{
            shapeLayer.lineWidth = lineWidth
        }
    }
        
    var originalImage: UIImage? {
        didSet{
            self.originalImageView.image = self.originalImage
            if originalImage != nil {
                let widthRate = 1.0 * originalImage!.size.width / originalImageView.frame.size.width
                let heightRate = 1.0 * originalImage!.size.height / originalImageView.frame.size.height
                imageRatio = widthRate > heightRate ? widthRate : heightRate
            }
        }
    }
    fileprivate var imageRatio:CGFloat = 1.0

    var maskImage: UIImage? {
        didSet{
            self.maskImageView.image = self.maskImage
        }
    }

    // undo, redo, reset related
    var currentIndex = 0
    var operationCount = 0
    fileprivate var fingerPath = CGMutablePath()
    fileprivate var fingerPathArray = [CGMutablePath]()
    fileprivate let shapeLayer = CAShapeLayer()
    fileprivate let originalImageView = UIImageView()
    let maskImageView = UIImageView()
    fileprivate var finderPathAllPoints = [[CGPoint]]()
    
    
    // initialization
    init(frame: CGRect, originalImage: UIImage, maskImage: UIImage) {
        super.init(frame: frame)
        setupUI()
        self.originalImage = originalImage
        originalImageView.image = originalImage
        
        let widthRatio = 1.0 * originalImage.size.width / originalImageView.frame.size.width
        let heightRatio = 1.0 * originalImage.size.height / originalImageView.frame.size.height
        self.imageRatio = widthRatio > heightRatio ? widthRatio : heightRatio
        
        
        self.maskImage = maskImage
        maskImageView.image = maskImage
        let sizeAfterFix = maskImage.size.ll_getRectAfterCropToSize(to: maskImageView.size)
        maskImageAfterCrop = maskImage.crop(toRect: sizeAfterFix)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    fileprivate func setupUI() {
        originalImageView.frame = frame
        originalImageView.contentMode = .scaleAspectFit
        originalImageView.backgroundColor = .black
        maskImageView.frame = frame
        maskImageView.contentMode = .scaleAspectFill
        layer.addSublayer(maskImageView.layer)
        layer.addSublayer(originalImageView.layer)
        
        originalImageView.layer.mask = shapeLayer
        shapeLayer.frame = frame
        shapeLayer.lineCap = lineCap;
        shapeLayer.lineJoin = lineJoin;
        shapeLayer.lineWidth = lineWidth;
        shapeLayer.strokeColor = .init(srgbRed: 0, green: 0, blue: 1, alpha: 1);
        shapeLayer.fillColor = .none;

        reset()
    }
    
    func undo() {
        if currentIndex == 0 {
            return
        }
        currentIndex -= 1
        fingerPath = fingerPathArray[currentIndex].mutableCopy()!
        shapeLayer.path = fingerPath
    }
    
    func canRedo() -> Bool {
        return currentIndex < operationCount
    }
    
    func canUndo() -> Bool {
        return currentIndex > 0
    }
    
    func redo() {
        if currentIndex == operationCount {
            return
        }
        currentIndex += 1
        fingerPath = fingerPathArray[currentIndex].mutableCopy()!
        shapeLayer.path = fingerPath
    }
    
    func reset() {
        fingerPath = CGMutablePath()
        shapeLayer.path = fingerPath
        fingerPathArray.removeAll()
        fingerPathArray.append(CGMutablePath())
        finderPathAllPoints.removeAll()
        currentIndex = 0
        operationCount = 0
    }
    
    var maskImageAfterCrop: UIImage?
    
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func snapshotLossless() -> UIImage? {
        if currentIndex == 0 {
            return maskImageAfterCrop
        }

        guard let size = originalImage?.size else { return maskImageAfterCrop }
        
        let wScale = size.width / originalImageView.width
        let hScale = size.height / originalImageView.height
        
        var newSize = size
        var point = CGPoint.zero
        if wScale > hScale {
            newSize.height = size.height / hScale * wScale
            point = CGPoint.init(x: 0, y: (newSize.height - size.height) / 2.0)
        }else{
            newSize.width = size.width / wScale * hScale
            point = CGPoint.init(x: (newSize.width - size.width) / 2, y: 0)
        }
        
        let renderer1 = UIGraphicsImageRenderer(size: newSize)
        
        let topImage = renderer1.image { ctx in
            maskImageAfterCrop?.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
            
            for i in 0..<currentIndex {
                let points = finderPathAllPoints[i]
                if points.count > 0 {
                    ctx.cgContext.move(to: CGPoint.init(x: points[0].x * imageRatio, y: points[0].y * imageRatio))
                    var j = 1
                    while j < points.count {
                        ctx.cgContext.addLine(to: CGPoint.init(x: points[j].x * imageRatio, y: points[j].y * imageRatio))
                        j += 1
                    }
                }
            }

            ctx.cgContext.setLineWidth(lineWidth * imageRatio)
            ctx.cgContext.setLineCap(cgLineCap)
            ctx.cgContext.setLineJoin(cgLineJoin)
            ctx.cgContext.setBlendMode(CGBlendMode.clear)
//            ctx.cgContext.setStrokeColor(UIColor.clear.cgColor)
            ctx.cgContext.strokePath()

        }
        
        
        let result = renderer1.image { ctx in
            if nil != originalImage {
                if originalImage!.size.width / newSize.width != originalImage!.size.height / newSize.height {
                    let blackImage = UIImage.imageWithColorSize(color: originalImageView.backgroundColor ?? UIColor.black, size: CGSize.init(width: 1, height: 1))
                    blackImage.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
                }
                originalImage?.draw(in: CGRect.init(origin: point, size: size))
            }
            topImage.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }

        return result
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if operationCount > currentIndex {
            while fingerPathArray.count > currentIndex + 1{
                fingerPathArray.removeLast()
            }
            while finderPathAllPoints.count > currentIndex + 1 {
                finderPathAllPoints.removeLast()
            }
            operationCount = currentIndex
        }
        super.touchesBegan(touches, with: event)
        let point = touches.first!.location(in: self)
        fingerPath.move(to: point)
        finderPathAllPoints.append([point])
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let point = touches.first!.location(in: self)
        fingerPath.addLine(to: point)
        shapeLayer.path = fingerPath
        finderPathAllPoints[finderPathAllPoints.count - 1].append(point)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        currentIndex += 1
        operationCount = currentIndex
        fingerPathArray.append(fingerPath.mutableCopy()!)
    }
    
    
    var lineCap = CAShapeLayerLineCap.butt {
        didSet{
            shapeLayer.lineCap = lineCap
            switch lineCap {
            case CAShapeLayerLineCap.butt:
                cgLineCap = .butt
            case CAShapeLayerLineCap.round:
                cgLineCap = .round
            case CAShapeLayerLineCap.square:
                cgLineCap = .square
            default:
                cgLineCap = .butt
            }
        }
    }
    fileprivate var cgLineCap:CGLineCap = .butt
    
    var lineJoin = CAShapeLayerLineJoin.bevel {
        didSet{
            shapeLayer.lineJoin = lineJoin
            switch lineJoin {
            case .bevel:
                cgLineJoin = .bevel
            case .miter:
                cgLineJoin = .miter
            case .round:
                cgLineJoin = .round
            default:
                cgLineJoin = .bevel
            }
        }
    }
    fileprivate var cgLineJoin:CGLineJoin = .bevel
    

    override var frame: CGRect{
        didSet{
            originalImageView.frame = frame
            maskImageView.frame = frame
        }
    }
    
    
}
