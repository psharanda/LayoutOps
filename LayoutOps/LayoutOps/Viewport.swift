//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public struct Viewport {
    let topAnchor: VAnchor?
    let bottomAnchor: VAnchor?
    let leftAnchor: HAnchor?
    let rightAnchor: HAnchor?
    
    public init(topAnchor: VAnchor? = nil, leftAnchor: HAnchor? = nil, bottomAnchor: VAnchor? = nil, rightAnchor: HAnchor? = nil) {
        self.topAnchor = topAnchor
        self.leftAnchor = leftAnchor
        self.bottomAnchor = bottomAnchor
        self.rightAnchor = rightAnchor
    }
    
    func apply(bounds: CGRect, layouts: ViewLayoutMap) -> CGRect {
        let left = leftAnchor.flatMap { $0.anchorValue(layouts) } ?? bounds.origin.x
        let top = topAnchor.flatMap { $0.anchorValue(layouts) } ?? bounds.origin.y
        let right = rightAnchor.flatMap { $0.anchorValue(layouts) } ?? bounds.maxX
        let bottom = bottomAnchor.flatMap { $0.anchorValue(layouts) } ?? bounds.maxY
        
        return CGRect(x: left, y: top, width: right - left, height: bottom - top)
    }
    
    func verify(superview: Layoutable) {
        
        
        var topIsWrong = false
        var leftIsWrong = false
        var bottomIsWrong = false
        var rightIsWrong = false
        
        if let tv = topAnchor?.view where tv.parent !== superview {
            topIsWrong = true
        }
        
        if let lv = leftAnchor?.view where lv.parent  !== superview {
            leftIsWrong = true
        }
        
        if let bv = bottomAnchor?.view where bv.parent  !== superview {
            bottomIsWrong = true
        }
        
        if let rv = rightAnchor?.view where rv.parent  !== superview {
            rightIsWrong = true
        }
        
        if topIsWrong || leftIsWrong || bottomIsWrong || rightIsWrong {
            
            print("[LayoutOps:WARNING] Viewport anchor views have different superviews")
            if topIsWrong {
                print("Top Anchor is Wrong: \(topAnchor?.view)")
            }
            if leftIsWrong {
                print("Left Anchor is Wrong: \(leftAnchor?.view)")
            }
            if bottomIsWrong {
                print("Bottom Anchor is Wrong: \(bottomAnchor?.view)")
            }
            if rightIsWrong {
                print("Right Anchor is Wrong: \(rightAnchor?.view)")
            }
        }
    }
}

/************************************************************************************/
/*[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]*/
/************************************************************************************/


extension Layouting where Base: Layoutable {
    
    public func inViewport(insets insets: UIEdgeInsets, @noescape block:()->Void) -> Layouting<Base> {
        let oldInsets = base.viewportInsets
        base.viewportInsets = insets
        block()
        base.viewportInsets = oldInsets
        return self
    }
    
    public func inViewport(topAnchor topAnchor: VAnchor? = nil, leftAnchor: HAnchor? = nil, bottomAnchor: VAnchor? = nil, rightAnchor: HAnchor? = nil, @noescape block:()->Void) -> Layouting<Base> {
        
        let left = leftAnchor.flatMap { $0.valueForRect($0.view.frame)} ?? base.bounds.origin.x
        let top = topAnchor.flatMap { $0.valueForRect($0.view.frame)} ?? base.bounds.origin.y
        let right = rightAnchor.flatMap { $0.valueForRect($0.view.frame) } ?? base.bounds.maxX
        let bottom = bottomAnchor.flatMap { $0.valueForRect($0.view.frame) } ?? base.bounds.maxY                        
        
        return inViewport(insets: UIEdgeInsets(top: top, left: left, bottom: base.bounds.height - bottom, right: base.bounds.width - right), block: block)
    }
}
