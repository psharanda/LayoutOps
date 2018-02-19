//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation
#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

private var viewPortInsetsKey: UInt8 = 0

extension UIView: Layoutable {
    
    public var lx_frame: CGRect {
        get {
            return frame
        }
        set {
            frame = newValue
        }
    }
    
    public var lx_parent: Layoutable? {
        return superview
    }
    
    public var lx_viewport: CGRect? {
        set {
            objc_setAssociatedObject(self, &viewPortInsetsKey, newValue.map { NSValue(cgRect: $0) }, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &viewPortInsetsKey) as? NSValue)?.cgRectValue
        }
    }
}

extension UIView: LayoutingCompatible { }

extension UIView: SelfSizingLayoutable { }

extension UILabel: Baselinable {
    public func baselineValueOfType(_ type: BaselineType, size: CGSize) -> CGFloat {
        let sz = sizeThatFits(size)
        
        switch type {
        case .first:
            return (size.height - sz.height)/2 + font.ascender
        case .last:
            return size.height - (size.height - sz.height)/2 + font.descender
        }
    }
}

extension UILabel: LayoutableWithFont {
    
}

private var key: UInt8 = 0

extension UIView: NodeContainer {
    
    public func lx_add(child: NodeContainer) {
        if let child = child as? UIView {
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
