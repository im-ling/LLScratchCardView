# LLScratchCardView
A scratch card view for iOS, support undo, redo, reset, snapshot,pixellate, etc

![](scratch.gif)


### Usage
```
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = view.frame
        guard let originalImage = UIImage.init(named: "tifa")?.ll_getAspectFillImage(imageViewSize: frame.size),
            let maskImage = UIImage.init(named: "ff7")?.ll_getAspectFillImage(imageViewSize: frame.size) else { return }
        scratchView = LLScratchCardView.init(frame: frame, originalImage: originalImage, maskImage: maskImage)
        view.addSubview(scratchView!)
    }
```

### undo, redo, reset, snapshot
just invoke functions below
```
    scratchView?.undo()
    scratchView?.redo()
    scratchView?.reset()
    scratchView?.snapshot()
```