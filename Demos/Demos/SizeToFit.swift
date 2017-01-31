//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit
import LayoutOps

class SizeToFitDemo_Value: UIView, DemoViewProtocol {
    
    
    let icon = makeHeartView()
    let label = makeDetailsLabel()
    let title = makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(label)
        addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.lx
            .sizeToFit(width: .Value(100), height: .Value(100))
            .alignTop(10)
            .hcenter()
        
        label.lx
            .sizeToFit(width: .Value(100), height: .Value(100))
            .center()
        
        title.lx.sizeToFit(width: .Value(100), height: .Value(100))
            .alignBottom(10)
            .hcenter()
        
    }
    
    static let title = ".Value"
    static let comments = "SizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. .Value option sets exact value for box. Result size will be equal or less than it."
}

class SizeToFitDemo_Max: UIView, DemoViewProtocol {
    
    let icon = makeHeartView()
    let label = makeDetailsLabel()
    let title = makeTitleLabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(label)
        addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.lx.sizeToFitMax()  //same as view.lx.sizeToFit(width: .Max, height: .Max)
            .alignTop(10)
            .hcenter()
        
        label.lx.sizeToFit(width: .Max, height: .Max)
            .center()
        
        title.lx.sizeToFit(width: .Max, height: .Max)
            .alignBottom(10)
            .hcenter()
        
    }
    
    static let title = ".Max"
    static let comments = ".Max option sets infinite value for fitting box. Result size will be most comfortable for view to display content. WARNING: multiline labels are comfortable with single line, don't use .Max for them"
}

class SizeToFitDemo_Current: UIView, DemoViewProtocol {
    
    let icon = makeHeartView()
    let label = makeDetailsLabel()
    let title = makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(label)
        addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.lx.set(size: CGSize(width: 200, height: 200))
            .sizeToFit(width: .Current, height: .Current)
            .alignTop(10)
            .hcenter()
        
        label.lx.hfill(leftInset: 20, rightInset: 20)
            .sizeToFit() //same as view.lx.sizeToFit(width: .Current, height: .Current)
            .center()
        
        title.lx.hfill(leftInset: 20, rightInset: 20)
            .sizeToFit(width: .Current, height: .Current)
            .alignBottom(10)
            .hcenter()
        
    }
    
    static let title = ".Current"
    static let comments = ".Current option sets value for box with current frame's width or height."
}

class SizeToFitDemo_KeepCurrent: UIView, DemoViewProtocol {
    
    let icon = makeHeartView()
    let label = makeDetailsLabel()
    let title = makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(label)
        addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.lx.set(size: CGSize(width: 200, height: 200))
            .sizeToFit(width: .KeepCurrent, height: .Max)
            .alignTop(10)
            .hcenter()
        
        label.lx.hfill(leftInset: 20, rightInset: 20)
            .sizeToFit(width: .KeepCurrent, height: .Max)
            .center()
        
        title.lx.hfill(leftInset: 20, rightInset: 20)
            .sizeToFit(width: .KeepCurrent, height: .Max)
            .alignBottom(10)
            .hcenter()
        
    }
    
    static let title = ".KeepCurrent"
    static let comments = ".KeepCurrent options sets value for box with current frame's width or height, but result size will be still equal to those original frame values. This is usefull to layout multiline labels. First you need to set somehow label width, and then call something like label.lx.sizeToFit(width: .KeepCurrent, height: .Max)."
}

class SizeToFitDemo_MinMax: UIView, DemoViewProtocol {
    
    let label = makeDetailsLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.lx
            .sizeToFitMax(widthConstraint: .Max(100), heightConstraint: .Min(300))
            .center()
        
    }
    
    static let title = "Min/Max constraints"
    static let comments = "SizeToFit operation also can have min, max or both constraints to limit resulted width/height. "
}