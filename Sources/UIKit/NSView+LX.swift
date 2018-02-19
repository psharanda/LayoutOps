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

private var viewPortInsetsKey: UInt8 = 0

extension NSView: Layoutable {
    public var lx_parent: Layoutable? {
        return superview
    }
    
    public var lx_frame: CGRect {
        get {
            if superview?.isFlipped ?? false {
                return frame
            } else {                
                return frame.flipped(in: superview?.bounds)
            }
        }
        set {
            if superview?.isFlipped ?? false {
                frame = newValue
            } else {
                frame = newValue.flipped(in: superview?.bounds)
            }
            
        }
    }
    
    public var lx_viewport: CGRect? {
        set {
            objc_setAssociatedObject(self, &viewPortInsetsKey, newValue.map { NSValue(rect: $0) }, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &viewPortInsetsKey) as? NSValue)?.rectValue
        }
    }
    
    public func lx_sizeThatFits(_ size: CGSize) -> CGSize {
        
        if let control = self as? NSControl {
            return control.sizeThatFits(size)
        }
        else if let imageView = self as? NSImageView {
            return imageView.image?.size ?? CGSize()
        }
        
        return CGSize()
    }
}

extension NSView: LayoutingCompatible { }

private var key: UInt8 = 0

extension NSView: NodeContainer {
    
    public func lx_add(child: NodeContainer) {
        if let child = child as? NSView {
            addSubview(child)
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
        for v in subviews {
            if v.lx_tag == Optional.some(tag) {
                return v
            }
        }
        return nil
    }
}
