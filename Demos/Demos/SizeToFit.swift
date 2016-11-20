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
        
        Combine(
            SizeToFit(icon, width: .value(100), height: .value(100)),
            AlignTop(icon, inset: 10),
            HCenter(icon),
            
            SizeToFit(label, width: .value(100), height: .value(100)),
            Center(label),
            
            SizeToFit(title, width: .value(100), height: .value(100)),
            AlignBottom(title, inset: 10),
            HCenter(title)
        ).layout()
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
        
        Combine(
            SizeToFitMax(icon),  //same as SizeToFit(view, width: .Max, height: .Max)
            AlignTop(icon, inset: 10),
            HCenter(icon),
            
            SizeToFit(label, width: .max, height: .max),
            Center(label),
            
            SizeToFit(title, width: .max, height: .max),
            AlignBottom(title, inset: 10),
            HCenter(title)
        ).layout()
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
        
        Combine(
            SetSize(icon, size: CGSize(width: 200, height: 200)),
            SizeToFit(icon, width: .current, height: .current),
            AlignTop(icon, inset: 10),
            HCenter(icon),
            
            HFill(label, leftInset: 20, rightInset: 20),
            SizeToFit(label), //same as SizeToFit(view, width: .Current, height: .Current)
            Center(label),
            
            HFill(title, leftInset: 20, rightInset: 20),
            SizeToFit(title, width: .current, height: .current),
            AlignBottom(title, inset: 10),
            HCenter(title)
        ).layout()
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
        
        Combine(
            
            SetSize(icon, size: CGSize(width: 200, height: 200)),
            SizeToFit(icon, width: .keepCurrent, height: .max),
            AlignTop(icon, inset: 10),
            HCenter(icon),
            
            HFill(label, leftInset: 20, rightInset: 20),
            SizeToFit(label, width: .keepCurrent, height: .max),
            Center(label),
            
            HFill(title, leftInset: 20, rightInset: 20),
            SizeToFit(title, width: .keepCurrent, height: .max),
            AlignBottom(title, inset: 10),
            HCenter(title)
        ).layout()
    }
    
    static let title = ".KeepCurrent"
    static let comments = ".KeepCurrent options sets value for box with current frame's width or height, but result size will be still equal to those original frame values. This is usefull to layout multiline labels. First you need to set somehow label width, and then call something like SizeToFit(label, width: .KeepCurrent, height: .Max)."
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
        
        Combine(
            SizeToFitMaxWithConstraints(label, widthConstraint: .max(100), heightConstraint: .min(300)),
            Center(label)
        ).layout()
    }
    
    static let title = "Min/Max constraints"
    static let comments = "SizeToFit operation also can have min, max or both constraints to limit resulted width/height. "
}
