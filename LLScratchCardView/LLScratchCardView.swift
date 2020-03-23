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

    
    fileprivate var fingerPath = CGMutablePath()
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

    fileprivate func setupUI(){
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let point = touches.first!.location(in: self)
        fingerPath.move(to: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let point = touches.first!.location(in: self)
        self.fingerPath.addLine(to: point)
        self.shapeLayer.path = self.fingerPath
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
