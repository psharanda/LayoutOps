//
//  Created by Pavel Sharanda on 09.02.2018.
//  Copyright © 2018 LayoutOps. All rights reserved.
//

import Foundation
#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

private var key: UInt8 = 0
private var viewPortInsetsKey: UInt8 = 0

extension CALayer: Layoutable {
    
    public var lx_frame: CGRect {
        get {
            #if os(macOS)
                return frame.flipped(in: superlayer?.bounds)
            #else
                return frame
            #endif
        }
        set {
            #if os(macOS)
                frame = newValue.flipped(in: superlayer?.bounds)
            #else
                frame = newValue
            #endif
        }
        
    }
    
    public func lx_sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize()
    }
    
    public var lx_parent: Layoutable? {
        return superlayer
    }
    
    public var lx_viewport: CGRect? {
        set {
            #if os(macOS)
                objc_setAssociatedObject(self, &viewPortInsetsKey, newValue.map { NSValue(rect: $0) }, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            #else
                objc_setAssociatedObject(self, &viewPortInsetsKey, newValue.map { NSValue(cgRect: $0) }, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            #endif
            
        }
        get {
            #if os(macOS)
                return (objc_getAssociatedObject(self, &viewPortInsetsKey) as? NSValue)?.rectValue
            #else
                return (objc_getAssociatedObject(self, &viewPortInsetsKey) as? NSValue)?.cgRectValue
            #endif
            
        }
    }
}

extension CALayer: LayoutingCompatible { }

extension CALayer: NodeContainer {
    
    public func lx_add(child: NodeContainer) {
        if let child = child as? CALayer {
            addSublayer(child)
        }
    }
    
    public var lx_tag: String? {
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
    }
    
    public func lx_child(with tag: String) -> NodeContainer? {
        for v in sublayers ?? [] {
            if v.lx_tag == Optional.some(tag) {
                return v
            }
        }
        return nil
    }
}
