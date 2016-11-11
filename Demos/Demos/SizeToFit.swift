//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit
import LayoutOps

class SizeToFitDemo_Value: UIView {
    
    
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
            SizeToFit(icon, width: .Value(100), height: .Value(100)),
            AlignTop(icon, inset: 10),
            HCenter(icon),
            
            SizeToFit(label, width: .Value(100), height: .Value(100)),
            Center(label),
            
            SizeToFit(title, width: .Value(100), height: .Value(100)),
            AlignBottom(title, inset: 10),
            HCenter(title)
        ).layout()
    }
}

class SizeToFitDemo_Max: UIView {
    
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
            
            SizeToFit(label, width: .Max, height: .Max),
            Center(label),
            
            SizeToFit(title, width: .Max, height: .Max),
            AlignBottom(title, inset: 10),
            HCenter(title)
        ).layout()
    }
}

class SizeToFitDemo_Current: UIView {
    
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
            SizeToFit(icon, width: .Current, height: .Current),
            AlignTop(icon, inset: 10),
            HCenter(icon),
            
            HFill(label, leftInset: 20, rightInset: 20),
            SizeToFit(label), //same as SizeToFit(view, width: .Current, height: .Current)
            Center(label),
            
            HFill(title, leftInset: 20, rightInset: 20),
            SizeToFit(title, width: .Current, height: .Current),
            AlignBottom(title, inset: 10),
            HCenter(title)
        ).layout()
    }
}

class SizeToFitDemo_KeepCurrent: UIView {
    
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
            SizeToFit(icon, width: .KeepCurrent, height: .Max),
            AlignTop(icon, inset: 10),
            HCenter(icon),
            
            HFill(label, leftInset: 20, rightInset: 20),
            SizeToFit(label, width: .KeepCurrent, height: .Max),
            Center(label),
            
            HFill(title, leftInset: 20, rightInset: 20),
            SizeToFit(title, width: .KeepCurrent, height: .Max),
            AlignBottom(title, inset: 10),
            HCenter(title)
        ).layout()
    }
}

class SizeToFitDemo_MinMax: UIView {
    
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
            SizeToFitMaxWithConstraints(label, widthConstraint: .Max(100), heightConstraint: .Min(300)),
            Center(label)
        ).layout()
    }
}