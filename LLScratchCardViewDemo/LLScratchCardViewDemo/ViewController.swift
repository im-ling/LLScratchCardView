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
        guard let originalImage = UIImage.init(named: "tifa")?.ll_getAspectFillImage(imageViewSize: view.size),
            let maskImage = UIImage.init(named: "aerith")?.ll_getAspectFillImage(imageViewSize: view.size) else { return }
        scratchView = LLScratchCardView.init(frame: view.frame, originalImage: originalImage, maskImage: maskImage)
        view.addSubview(scratchView!)

        let tintColor = UIColor.colorWithHex(hex: 0x6A81F9)
        let undoBtn = UIButton.ll_button(title: "Undo", target: self, action: #selector(undoButtionClickAction(sender:)), color: tintColor)
        let resetBtn = UIButton.ll_button(title: "Reset", target: self, action: #selector(reset), color: tintColor)
        let redoBtn = UIButton.ll_button(title: "Redo", target: self, action: #selector(redoClickAction(sender:)), color:  tintColor)
        let doneBtn = UIButton.ll_button(title: "Done", target: self, action: #selector(doneButtonClickAction(sender:)), color: tintColor)

        let height:CGFloat = 45.0
        let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: view.height - height - UIApplication.shared.statusBarFrame.size.height, width: view.width, height: height ))
        view.addSubview(toolBar)
        
        var barItems = [UIBarButtonItem]()
        barItems.append(UIBarButtonItem.init(customView: undoBtn))
        barItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        barItems.append(UIBarButtonItem.init(customView: resetBtn))
        barItems.append(UIBarButtonItem.init(customView: UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 10, height: height)))))
        barItems.append(UIBarButtonItem.init(customView: doneBtn))
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
    
    @objc func doneButtonClickAction(sender: UIButton){
        let vc = ResultImageController.init(frame: view.frame)
        let snapshot = scratchView?.snapshot()
        vc.image = snapshot
        vc.view.backgroundColor = .gray
        present(vc, animated: true, completion: nil)
    }
    
    
}

