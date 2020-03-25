//
//  ViewController.swift
//  LLScratchCardViewDemo
//
//  Created by NowOrNever on 22/03/2020.
//  Copyright © 2020 LL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scratchView: LLScratchCardView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let frame = view.frame
        guard let originalImage = UIImage.init(named: "tifa")?.ll_getAspectFillImage(imageViewSize: frame.size),
            let maskImage = UIImage.init(named: "ff7")?.ll_getAspectFillImage(imageViewSize: frame.size) else { return }
        scratchView = LLScratchCardView.init(frame: frame, originalImage: originalImage, maskImage: maskImage)
        view.addSubview(scratchView!)

        let tintColor = UIColor.colorWithHex(hex: 0x6A81F9)
        let undoBtn = UIButton.ll_button(title: "Undo", target: self, action: #selector(undoButtionClickAction(sender:)), color: tintColor)
        let resetBtn = UIButton.ll_button(title: "Reset", target: self, action: #selector(reset), color: tintColor)
        let doneBtn = UIButton.ll_button(title: "Done", target: self, action: #selector(doneButtonClickAction(sender:)), color: tintColor)
        let nextBtn = UIButton.ll_button(title: "Next", target: self, action: #selector(nextButtonClickAction(sender:)), color: tintColor)
        let redoBtn = UIButton.ll_button(title: "Redo", target: self, action: #selector(redoClickAction(sender:)), color:  tintColor)

        let height:CGFloat = 45.0
        let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: view.height - height - UIApplication.shared.statusBarFrame.size.height, width: view.width, height: height ))
        view.addSubview(toolBar)
        
        var barItems = [UIBarButtonItem]()
        barItems.append(UIBarButtonItem.init(customView: undoBtn))
        barItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        barItems.append(UIBarButtonItem.init(customView: resetBtn))
        barItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        barItems.append(UIBarButtonItem.init(customView: doneBtn))
        barItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        barItems.append(UIBarButtonItem.init(customView: nextBtn))
        barItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        barItems.append(UIBarButtonItem.init(customView: redoBtn))
        toolBar.items = barItems
    }
    
    @objc func undoButtionClickAction(sender: UIButton){
        scratchView?.undo()
    }
    
    @objc func redoClickAction(sender: UIButton){
        scratchView?.redo()
    }
    
    @objc func reset(){
        scratchView?.reset()
    }
    
    
    var index = 0
    var imageName = ["aerith", "tifa", "yuffie"]
    var coverImage = UIImage.init(named: "ff7")

    @objc func nextButtonClickAction(sender: UIButton){
        switch index % imageName.count {
        case 0:
            let image = UIImage.init(named: imageName[0])
            scratchView?.originalImage = image?.ll_getAspectFillImage(imageViewSize: scratchView?.size)
            scratchView?.maskImage = image?.ll_getAspectFillImage(imageViewSize: scratchView?.size)?.blurImage(blurAmount: 15)
        case 1:
            let image = UIImage.init(named: imageName[1])
            scratchView?.originalImage = image?.ll_getAspectFillImage(imageViewSize: scratchView?.size)?.pixelImage(level: 20)
            scratchView?.maskImage = image?.ll_getAspectFillImage(imageViewSize: scratchView?.size)
        case 2:
            let originalImage = UIImage.init(named: imageName[2])?.ll_getAspectFillImage(imageViewSize: scratchView?.size)
            scratchView?.originalImage = originalImage
            scratchView?.maskImage = coverImage
        default:
            return
        }
        scratchView?.reset()
        index += 1
    }

    @objc func doneButtonClickAction(sender: UIButton){
        let vc = ResultImageController.init(frame: view.frame)
        let snapshot = scratchView?.snapshot()
        vc.image = snapshot
        vc.view.backgroundColor = .gray
        present(vc, animated: true, completion: nil)
    }
    
}

