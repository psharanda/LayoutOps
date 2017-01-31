//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

private var viewPortInsetsKey: UInt8 = 0

extension UIView: Layoutable {
    public var parent: Layoutable? {
        return superview
    }
    
    public var viewportInsets: UIEdgeInsets {
        set {
            objc_setAssociatedObject(self, &viewPortInsetsKey, NSValue(UIEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &viewPortInsetsKey) as? NSValue)?.UIEdgeInsetsValue() ?? UIEdgeInsets()
        }
    }
}

extension UIView: LayoutingCompatible { }

extension UILabel: Baselinable {
    public func baselineValueOfType(type: BaselineType, size: CGSize) -> CGFloat {
        let sz = sizeThatFits(size)
        
        switch type {
        case .First:
            return (size.height - sz.height)/2 + font.ascender
        case .Last:
            return size.height - (size.height - sz.height)/2 + font.descender
        }
    }
}

extension UILabel: LayoutableWithFont {
    
}

extension CALayer: Layoutable {
    public var parent: Layoutable? {
        return superlayer
    }
    
    public func sizeThatFits(size: CGSize) -> CGSize {
        return CGSize()
    }
    
    public var viewportInsets: UIEdgeInsets {
        set {
            objc_setAssociatedObject(self, &viewPortInsetsKey, NSValue(UIEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &viewPortInsetsKey) as? NSValue)?.UIEdgeInsetsValue() ?? UIEdgeInsets()
        }
    }
}

extension CALayer: LayoutingCompatible { }






