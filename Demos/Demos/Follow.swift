//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit
import LayoutOps

class FollowDemo_CornerAnchors: UIView, DemoViewProtocol {
    
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
        
        greenView.lx.set(width: 50, height: 190)
        greenView.lx.leftAnchor.follow(blueView.lx.rightAnchor)
        greenView.lx.topAnchor.follow(blueView.lx.bottomAnchor)
        
        redView.lx.set(width: 30, height: 30)
        redView.lx.leftAnchor.follow(blueView.lx.leftAnchor)
        redView.lx.bottomAnchor.follow(greenView.lx.bottomAnchor)
                
    }
    
    static let title = "Corners"
    static let comments = "Follow operation makes one view's anchor to be the same with others view anchor. Anchors can be horizontal and vertical, and can be followed only with anchors of the same type"
}

class FollowDemo_CenterAnchors: UIView, DemoViewProtocol {
    
    
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
            .set(width: 200)
            .vfill(inset: 20)
        
        greenView.lx.set(width: 50, height: 190)
        greenView.lx.leftAnchor.follow(blueView.lx.rightAnchor)
        greenView.lx.vcenterAnchor.follow(blueView.lx.vcenterAnchor)
        
        redView.lx.set(width: 30, height: 30)
        redView.lx.hcenterAnchor.follow(greenView.lx.hcenterAnchor)
        redView.lx.vcenterAnchor.follow(greenView.lx.vcenterAnchor)
        
    }
    
    static let title = "Center"
    static let comments = "There are not only edge anchors, but also center anchors"
}

class FollowDemo_SizeAnchors: UIView, DemoViewProtocol {
    
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
        
        blueView.lx.set(x: 10)
            .set(width: 50)
            .vfill(inset: 100)
        
        greenView.lx.heightAnchor.follow(blueView.lx.widthAnchor)
        greenView.lx.widthAnchor.follow(blueView.lx.heightAnchor)
        greenView.lx.leftAnchor.follow(blueView.lx.rightAnchor)
        greenView.lx.topAnchor.follow(blueView.lx.bottomAnchor)
        
    }
    
    static let title = "Size"
    static let comments = "There are also size anchors"
}

class FollowDemo_firstBaselineAnchors: UIView, DemoViewProtocol {
    
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
        
        label.lx.hfill(inset: 20)
            .sizeToFit(width: .KeepCurrent, height: .Max)
            .center()
        
        blueView.lx.set(height: 30)
            .hfill(inset: 20)
        
        greenView.lx.set(height: 30)
            .hfill(inset: 20)
        
        blueView.lx.bottomAnchor.follow(label.lx.firstBaselineAnchor)
        greenView.lx.topAnchor.follow(label.lx.lastBaselineAnchor)
        
    }
    
    static let title = "Baseline"
    static let comments = "firstBaselineAnchor/lastBaselineAnchor anchors are special. Only Baselinable views have it. For the moment only UILabel is conforming this protocol"
}
 