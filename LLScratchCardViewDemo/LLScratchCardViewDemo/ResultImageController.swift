//
//  ResultImageController.swift
//  LLScratchCardViewDemo
//
//  Created by NowOrNever on 23/03/2020.
//  Copyright © 2020 LL. All rights reserved.
//

import UIKit
class ResultImageController: UIViewController {
    let imageView = UIImageView()
    var image: UIImage? {
        didSet{
            imageView.image = image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    init(frame: CGRect) {
        super.init(nibName: nil, bundle: nil)
        view.frame = frame
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    func setupUI() {
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true, completion: nil)
    }
    
}
