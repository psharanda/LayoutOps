//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

extension Layouting where Base: Layoutable {
    
    public func inViewport(rect rect: CGRect, @noescape block:()->Void) -> Layouting<Base> {
        let oldViewport = base.__lx_viewport
        base.__lx_viewport = rect
        block()
        base.__lx_viewport = oldViewport
        return self
    }
    
    public func inViewport(topAnchor topAnchor: VAnchor? = nil, leftAnchor: HAnchor? = nil, bottomAnchor: VAnchor? = nil, rightAnchor: HAnchor? = nil, @noescape block:()->Void) -> Layouting<Base> {
        
        let left = leftAnchor.flatMap { $0.valueForRect($0.view.frame)} ?? base.bounds.origin.x
        let top = topAnchor.flatMap { $0.valueForRect($0.view.frame)} ?? base.bounds.origin.y
        let right = rightAnchor.flatMap { $0.valueForRect($0.view.frame) } ?? base.bounds.maxX
        let bottom = bottomAnchor.flatMap { $0.valueForRect($0.view.frame) } ?? base.bounds.maxY                        
        
        return inViewport(rect: CGRect(x: left, y: top, width: right - left, height: bottom - top), block: block)
    }
}
