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
        
        blueView.lx.set(x: 10, y: 10)
            .set(width: 100, height: 100)
        
        greenView.lx.set(x: 120, y: 20, width: 50, height: 190)
        
        redView.lx.set(x: 5)
            .set(y: 120)
            .set(width: 45)
            .set(height: 100)
    }
  
    static let title = "Set*"
    static let comments = "set* operations directly put frame values"
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
        
        
        blueView.lx.set(y: 5)
            .set(width: 100, height: 100)
            .hcenter()
        
        greenView.lx.set(x: 5)
            .set(width: 50, height: 120)
            .vcenter(topInset: 0, bottomInset: 100)
        
        redView.lx.set(width: 45, height: 100)
            .center()
        
    }
    
    static let title = "Center"
    static let comments = "hcenter (horizontally), vcenter (vertically) and center (both) operations allows to center view in superview. Insets can be used to adjust center point (see green view, 100 pt from bottom). Size of view usually should be set with previous operations"
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
        
        
        redView.lx.fill(inset: 5)
        
        blueView.lx.set(y: 20)
            .set(height: 50)
            .hfill(inset: 10)
        
        greenView.lx.set(x: 25)
            .set(width: 50)
            .vfill(topInset: 100, bottomInset: 15)
        
    }
    
    static let title = "Fill"
    static let comments = "hfill (horizontally), vfill (vertically) and fill (both) operations make view to fill its superview. Insets can be used to control how much space to be left unfilled from the superview edges"
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
        
        
        blueView.lx.set(width: 100, height: 100)
            .alignLeft(5)
            .alignTop(5)
        
        greenView.lx.set(width: 50, height: 120)
            .alignLeft(10)
            .alignBottom(15)
        
        redView.lx.set(width: 45, height: 100)
            .alignRight(25)
            .alignTop(25)
        
    }
    
    static let title = "Align"
    static let comments = "align* operations allow to put view relatively to edges of superview. Inset value can be used to set distance to edge. Size of view usually should be set with previous operations."
}


