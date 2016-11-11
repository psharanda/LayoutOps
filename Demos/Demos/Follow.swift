//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit
import LayoutOps

class FollowDemo_CornerAnchors: UIView {
    
    let blueView = makeBlueView()
    let greenView = makeGreenView()
    let redView = makeRedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(blueView)
        addSubview(greenView)
        addSubview(redView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Combine(
            SetOrigin(blueView, x: 10, y: 10),
            SetSize(blueView, width: 100, height: 100),            
            
            SetSize(greenView, width: 50, height: 190),
            Follow(RightAnchor(blueView), withAnchor: LeftAnchor(greenView)),
            Follow(BottomAnchor(blueView), withAnchor: TopAnchor(greenView)),
            
            SetSize(redView, width: 30, height: 30),
            Follow(LeftAnchor(blueView), withAnchor: LeftAnchor(redView)),
            Follow(BottomAnchor(greenView), withAnchor: BottomAnchor(redView))
            
        ).layout()
    }
}

class FollowDemo_CenterAnchors: UIView {
    
    
    let blueView = makeBlueView()
    let greenView = makeGreenView()
    let redView = makeRedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(blueView)
        addSubview(greenView)
        addSubview(redView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Combine(
            SetOrigin(blueView, x: 10, y: 10),
            SetWidth(blueView, value: 200),
            VFill(blueView, inset: 20),
            
            SetSize(greenView, width: 50, height: 190),
            Follow(RightAnchor(blueView), withAnchor: LeftAnchor(greenView)),
            Follow(VCenterAnchor(blueView), withAnchor: VCenterAnchor(greenView)),
            
            SetSize(redView, width: 30, height: 30),
            Follow(HCenterAnchor(greenView), withAnchor: HCenterAnchor(redView)),
            Follow(VCenterAnchor(greenView), withAnchor: VCenterAnchor(redView))
            
        ).layout()
    }
}

class FollowDemo_SizeAnchors: UIView {
    
    let blueView = makeBlueView()
    let greenView = makeGreenView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(blueView)
        addSubview(greenView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Combine(
            SetX(blueView, value: 10),
            
            SetWidth(blueView, value: 50),
            VFill(blueView, inset: 100),
            
            Follow(WidthAnchor(blueView), withAnchor: HeightAnchor(greenView)),
            Follow(HeightAnchor(blueView), withAnchor: WidthAnchor(greenView)),
            Follow(RightAnchor(blueView), withAnchor: LeftAnchor(greenView)),
            Follow(BottomAnchor(blueView), withAnchor: TopAnchor(greenView))
            
        ).layout()
    }
}

class FollowDemo_BaselineAnchors: UIView {
    
    let blueView = makeBlueView()
    let greenView = makeGreenView()
    let label = makeDetailsLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        addSubview(blueView)
        addSubview(greenView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Combine(
            
            HFill(label, inset: 20),
            SizeToFit(label, width: .KeepCurrent, height: .Max),
            Center(label),
            
            SetHeight(blueView, value: 30),
            SetHeight(greenView, value: 30),
            
            HFill(blueView, inset: 20),
            HFill(greenView, inset: 20),
            
            Follow(BaselineAnchor(label, type: .First), withAnchor: BottomAnchor(blueView)),
            Follow(BaselineAnchor(label, type: .Last), withAnchor: TopAnchor(greenView))
        ).layout()
    }
}
 