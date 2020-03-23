//
//  StructExtension.swift
//  LLScratchCardViewDemo
//
//  Created by NowOrNever on 23/03/2020.
//  Copyright © 2020 LL. All rights reserved.
//

import UIKit
extension CGSize {
    func ll_aspectExtend(to size:CGSize) -> CGSize {
        var newSize = size
        let wScale = size.width / width
        let hScale = size.height / height
        if wScale > hScale {
            newSize.height = height * wScale
        }else{
            newSize.width = width * hScale
        }
        return newSize
    }
    
    func ll_cropToSize(to size:CGSize) -> CGRect {
        var point = CGPoint.zero
        var newSize = CGSize.init(width: width, height: height)
        let wScale = width / size.width
        let hScale = height / size.height
        if wScale > hScale {
            newSize.width = newSize.width / wScale * hScale
            point.x = (self.width - newSize.width) / 2
        }else{
            newSize.height = newSize.height / hScale * wScale
            point.y = (self.height - newSize.height) / 2
        }
        return CGRect.init(origin: point, size: newSize)
    }
}

