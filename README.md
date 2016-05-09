# LayoutOps
Frame based layout library for UIKit written in Swift

# Usage

```swift
import UIKit

class ViewController: UIViewController {
    
    var redView: UIView! = nil
    var orangeView: UIView! = nil
    
    var label: UILabel! = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()

        orangeView = UIView.init()
        orangeView.backgroundColor = UIColor.orangeColor()
        view.addSubview(orangeView)
        
        redView = UIView.init()
        redView.backgroundColor = UIColor.redColor()
        view.addSubview(redView)
        
        label = UILabel()
        label.numberOfLines = 0
        label.text = "Nullam quis risus eget urna mollis ornare vel eu leo. Cras mattis consectetur purus sit amet fermentum. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum."
        view.addSubview(label)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Combine( [
            HPut(
                [Flex(), Fix(orangeView,100), Flex(2), Fix(redView, 100),Flex()]
            ),
            VPut(
                [Flex(), Fix(orangeView, 100), Flex()]
            ),
            VPut(
                [Flex(), Fix(redView, 100), Flex()]
            ),
            HFillVFit(label, inset: 20),
            AlignBottom(label, inset: 20)
            ]).layout()
    }
}
```   
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/demo.png" alt="Hello LayoutOps!!!" width="244" height="401"/>
