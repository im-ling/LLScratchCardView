//
//  ViewController.swift
//  LLScratchCardViewDemo
//
//  Created by NowOrNever on 22/03/2020.
//  Copyright © 2020 LL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scratchView = LLScratchCardView.init(frame: view.frame)
        view.addSubview(scratchView)
        // Do any additional setup after loading the view.
    }


}

