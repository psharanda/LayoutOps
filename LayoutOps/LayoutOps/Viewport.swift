//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public enum HViewAnchor {
    case Parent
    case Left(UIView)
    case HCenter(UIView)
    case Right(UIView)
    
    func anchorValue(layouts: ViewLayoutMap) -> CGFloat? {
        switch self {
        case .Parent:
            return nil
        case .Left(let v):
            return layouts[v]?.origin.x
        case .Right(let v):
            return layouts[v].flatMap { $0.origin.x + $0.size.width }
        case .HCenter(let v):
            return layouts[v].flatMap { $0.origin.x + $0.size.width/2 }
        }
    }
    
    var view: UIView? {
        switch self {
        case .Parent:
            return nil
        case .Left(let v):
            return v
        case .Right(let v):
            return v
        case .HCenter(let v):
            return v
        }
    }
}

public enum VViewAnchor {
    case Parent
    case Top(UIView)
    case Bottom(UIView)
    case VCenter(UIView)
    
    func anchorValue(layouts: ViewLayoutMap) -> CGFloat? {
        switch self {
        case .Parent:
            return nil
        case .Top(let v):
            return layouts[v]?.origin.y
        case .Bottom(let v):
            return layouts[v].flatMap { $0.origin.y + $0.size.height }
        case .VCenter(let v):
            return layouts[v].flatMap { $0.origin.y + $0.size.height/2 }
        }
    }
    
    var view: UIView? {
        switch self {
        case .Parent:
            return nil
        case .Top(let v):
            return v
        case .Bottom(let v):
            return v
        case .VCenter(let v):
            return v
        }
    }
}

public struct Viewport {
    let topAnchor: VViewAnchor
    let bottomAnchor: VViewAnchor
    let leftAnchor: HViewAnchor
    let rightAnchor: HViewAnchor
    
    public init(topAnchor: VViewAnchor, leftAnchor: HViewAnchor, bottomAnchor: VViewAnchor, rightAnchor: HViewAnchor) {
        self.topAnchor = topAnchor
        self.leftAnchor = leftAnchor
        self.bottomAnchor = bottomAnchor
        self.rightAnchor = rightAnchor
    }
    
    public init(topAnchor: VViewAnchor, bottomAnchor: VViewAnchor) {
        self.init(topAnchor: topAnchor, leftAnchor: .Parent, bottomAnchor: bottomAnchor, rightAnchor: .Parent)
    }
    
    public init(leftAnchor: HViewAnchor, rightAnchor: HViewAnchor) {
        self.init(topAnchor: .Parent, leftAnchor: leftAnchor, bottomAnchor: .Parent, rightAnchor: rightAnchor)
    }
    
    public init(topAnchor: VViewAnchor) {
        
        self.init(topAnchor: topAnchor, leftAnchor: .Parent, bottomAnchor: .Parent, rightAnchor: .Parent)
    }
    
    public init(leftAnchor: HViewAnchor) {
        self.init(topAnchor: .Parent, leftAnchor: leftAnchor, bottomAnchor: .Parent, rightAnchor: .Parent)
    }
    
    public init(bottomAnchor: VViewAnchor) {
        
        self.init(topAnchor: .Parent, leftAnchor: .Parent, bottomAnchor: bottomAnchor, rightAnchor: .Parent)
    }
    
    public init(rightAnchor: HViewAnchor) {
        self.init(topAnchor: .Parent, leftAnchor: .Parent, bottomAnchor: .Parent, rightAnchor: rightAnchor)
    }
    
    public init() {
        
        self.init(topAnchor: .Parent, leftAnchor: .Parent, bottomAnchor: .Parent, rightAnchor: .Parent)
    }
    
    func apply(bounds: CGRect, layouts: ViewLayoutMap) -> CGRect {
        let left = leftAnchor.anchorValue(layouts) ?? bounds.origin.x
        let top = topAnchor.anchorValue(layouts) ?? bounds.origin.y
        let right = rightAnchor.anchorValue(layouts) ?? bounds.maxX
        let bottom = bottomAnchor.anchorValue(layouts) ?? bounds.maxY
        
        return CGRect(x: left, y: top, width: right - left, height: bottom - top)
    }
    
    func verify(superview: UIView) {
        
        
        var topIsWrong = false
        var leftIsWrong = false
        var bottomIsWrong = false
        var rightIsWrong = false
        
        if let tv = topAnchor.view where tv.superview !== superview {
            topIsWrong = true
        }
        
        if let lv = leftAnchor.view where lv.superview  !== superview {
            leftIsWrong = true
        }
        
        if let bv = bottomAnchor.view where bv.superview  !== superview {
            bottomIsWrong = true
        }
        
        if let rv = rightAnchor.view where rv.superview  !== superview {
            rightIsWrong = true
        }
        
        if topIsWrong || leftIsWrong || bottomIsWrong || rightIsWrong {
            
            print("[LayoutOps:WARNING] Viewport anchor views have different superviews")
            if topIsWrong {
                print("Top Anchor is Wrong: \(topAnchor.view)")
            }
            if leftIsWrong {
                print("Left Anchor is Wrong: \(leftAnchor.view)")
            }
            if bottomIsWrong {
                print("Bottom Anchor is Wrong: \(bottomAnchor.view)")
            }
            if rightIsWrong {
                print("Right Anchor is Wrong: \(rightAnchor.view)")
            }
        }
    }
}