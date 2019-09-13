//
//  Created by Pavel Sharanda on 09.02.2018.
//  Copyright © 2018 LayoutOps. All rights reserved.
//

#if os(macOS)
import Cocoa

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
}

extension NSView: LayoutingCompatible { }

extension NSControl: SelfSizingLayoutable { }

private var key: UInt8 = 0

#endif
