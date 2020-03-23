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
            originalImageView.image = originalImage
        }
    }

    var maskImage: UIImage? {
        didSet{
            coverView.image = maskImage
        }
    }

    // undo, redo, reset related
    var currentIndex = 0
    var operationCount = 0
    fileprivate var fingerPath = CGMutablePath()
    fileprivate var fingerPathArray = [CGMutablePath]()
    fileprivate let shapeLayer = CAShapeLayer()
    fileprivate let originalImageView = UIImageView()
    fileprivate let coverView = UIImageView()
    
    init(frame: CGRect, originalImage: UIImage, maskImage: UIImage) {
        super.init(frame: frame)
        setupUI()
        self.originalImage = originalImage
        self.maskImage = maskImage
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
        coverView.frame = frame
        coverView.contentMode = .scaleAspectFit
        layer.addSublayer(coverView.layer)
        layer.addSublayer(originalImageView.layer)
        
        originalImageView.layer.mask = shapeLayer
        shapeLayer.frame = frame
        shapeLayer.lineCap = lineCap;
        shapeLayer.lineJoin = lineJoin;
        shapeLayer.lineWidth = lineWidth;
        shapeLayer.strokeColor = .init(srgbRed: 0, green: 0, blue: 1, alpha: 1);
        shapeLayer.fillColor = .none;

        // testcode
        coverView.backgroundColor = .blue
        originalImageView.backgroundColor = .orange
        
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
        currentIndex = 0
        operationCount = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let point = touches.first!.location(in: self)
        fingerPath.move(to: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let point = touches.first!.location(in: self)
        fingerPath.addLine(to: point)
        shapeLayer.path = fingerPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if operationCount > currentIndex {
            while fingerPathArray.count > currentIndex + 1{
                fingerPathArray.removeLast()
            }
        }
        currentIndex += 1
        operationCount = currentIndex
        fingerPathArray.append(fingerPath.mutableCopy()!)
    }
    
    
    var lineCap = CAShapeLayerLineCap.butt {
        didSet{
            shapeLayer.lineCap = lineCap
        }
    }
    var lineJoin = CAShapeLayerLineJoin.bevel {
        didSet{
            shapeLayer.lineJoin = lineJoin
        }
    }
    
    override var frame: CGRect{
        didSet{
            originalImageView.frame = frame
            coverView.frame = frame
        }
    }
    
    
}
