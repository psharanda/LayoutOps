//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//


import UIKit
import LayoutOps

class BasicDemo_Set: UIView, DemoViewProtocol {
    
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
            
            SetFrame(greenView, x: 120, y: 20, width: 50, height: 190),
            
            SetX(redView, value: 5),
            SetY(redView, value: 120),
            SetWidth(redView, value: 45),
            SetHeight(redView, value: 100)
        ).layout()
    }
  
    static let title = "Set*"
    static let comments = "Set* operations directly manipulate according frame values"
}

class BasicDemo_Center: UIView, DemoViewProtocol {
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
            SetY(blueView, value: 5),
            SetSize(blueView, width: 100, height: 100),
            HCenter(blueView),
            
            SetX(greenView, value: 5),
            SetSize(greenView, width: 50, height: 120),
            VCenter(greenView, topInset: 0, bottomInset: 100),
            
            SetSize(redView, width: 45, height: 100),
            Center(redView)
        ).layout()
    }
    
    static let title = "Center"
    static let comments = "HCenter (horizontally), VCenter (vertically) and Center (both) operations allows to center view. Insets can be used to adjust center point (see green view, 100 pt from bottom). Size of view usually should be set with previous operations"
}

class BasicDemo_Fill: UIView, DemoViewProtocol {
    
    let redView = makeRedView()
    let blueView = makeBlueView()
    let greenView = makeGreenView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(redView)
        addSubview(blueView)
        addSubview(greenView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Combine(
            Fill(redView, inset: 5),
            
            SetY(blueView, value: 20),
            SetHeight(blueView, value: 50),
            HFill(blueView, inset: 10),
            
            SetX(greenView, value: 25),
            SetWidth(greenView, value: 50),
            VFill(greenView, topInset: 100, bottomInset: 15)
            
        ).layout()
    }
    
    static let title = "Fill"
    static let comments = "HFill (horizontally), VFill (vertically) and Fill (both) operations make view to fill its superview. Insets can be used to control how much space to left unfilled from the superview edges"
}

class BasicDemo_Align: UIView, DemoViewProtocol {
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
            SetSize(blueView, width: 100, height: 100),
            AlignLeft(blueView, inset: 5),
            AlignTop(blueView, inset: 5),
            
            SetSize(greenView, width: 50, height: 120),
            AlignLeft(greenView, inset: 10),
            AlignBottom(greenView, inset: 15),
            
            SetSize(redView, width: 45, height: 100),
            AlignRight(redView, inset: 25),
            AlignTop(redView, inset: 25)
        ).layout()
    }
    
    static let title = "Align"
    static let comments = "Align* operations allow to put view relatively to edges of superview. Inset value can be used to determine distance to edge. Size of view usually should be set with previous operations."
}


