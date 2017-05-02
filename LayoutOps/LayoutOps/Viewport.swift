//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

extension Layouting where Base: Layoutable {
    
    @discardableResult
    public func inViewport(rect: CGRect, block: ()->Void) -> Layouting<Base> {
        let oldViewport = base.lx_viewport
        base.lx_viewport = rect
        block()
        base.lx_viewport = oldViewport
        return self
    }
    
    @discardableResult
    public func inViewport(topAnchor: VAnchor? = nil, leftAnchor: HAnchor? = nil, bottomAnchor: VAnchor? = nil, rightAnchor: HAnchor? = nil, block: ()->Void) -> Layouting<Base> {
        
        let left = leftAnchor.map { $0.valueForRect($0.view === base ? base.bounds : $0.view.frame)} ?? base.bounds.origin.x
        let top = topAnchor.map { $0.valueForRect($0.view === base ? base.bounds : $0.view.frame)} ?? base.bounds.origin.y
        let right = rightAnchor.map { $0.valueForRect($0.view === base ? base.bounds : $0.view.frame) } ?? base.bounds.maxX
        let bottom = bottomAnchor.map { $0.valueForRect($0.view === base ? base.bounds : $0.view.frame) } ?? base.bounds.maxY
        
        return inViewport(rect: CGRect(x: left, y: top, width: right - left, height: bottom - top), block: block)
    }
}
