//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

private var viewPortInsetsKey: UInt8 = 0

extension UIView: Layoutable {
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

extension CALayer: Layoutable {
    public var lx_parent: Layoutable? {
        return superlayer
    }
    
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize()
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

extension CALayer: LayoutingCompatible { }






