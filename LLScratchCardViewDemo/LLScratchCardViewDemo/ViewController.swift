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
        scratchView = LLScratchCardView.init(frame: view.frame)
        view.addSubview(scratchView!)

        let undoBtn = UIButton.init(title: "B", target: self, action: #selector(undoButtionClickAction(sender:)))
        let resetBtn = UIButton.init(title: "R", target: self, action: #selector(reset))
        let redoBtn = UIButton.init(title: "F", target: self, action: #selector(redoClickAction(sender:)))

        
        let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: view.width, height: 45))
        view.addSubview(toolBar)
        
        var barItems = [UIBarButtonItem]()
        barItems.append(UIBarButtonItem.init(customView: undoBtn))
        barItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        barItems.append(UIBarButtonItem.init(customView: resetBtn))
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
    
    
}

