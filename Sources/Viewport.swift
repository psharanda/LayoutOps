//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

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
        
        let left = leftAnchor.map { $0.valueForRect($0.view === base ? base.lx_bounds : $0.view.lx_frame)} ?? base.lx_bounds.origin.x
        let top = topAnchor.map { $0.valueForRect($0.view === base ? base.lx_bounds : $0.view.lx_frame)} ?? base.lx_bounds.origin.y
        let right = rightAnchor.map { $0.valueForRect($0.view === base ? base.lx_bounds : $0.view.lx_frame) } ?? base.lx_bounds.maxX
        let bottom = bottomAnchor.map { $0.valueForRect($0.view === base ? base.lx_bounds : $0.view.lx_frame) } ?? base.lx_bounds.maxY
        
        return inViewport(rect: CGRect(x: left, y: top, width: right - left, height: bottom - top), block: block)
    }
}
