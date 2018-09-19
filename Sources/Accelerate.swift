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

//some common, but very specific ops

public protocol LayoutableWithFont: Layoutable {
    
    #if os(macOS)
    var font: NSFont! {get}
    #else
    var font: UIFont! {get}
    #endif
}

extension Layouting where Base: LayoutableWithFont {
    
    @discardableResult
    public func alignToFirstBaseline<T: LayoutingCompatible>(ofSingleLineFittedLabel label: T) -> Layouting<Base> where T: LayoutableWithFont {
        topAnchor.insettedBy(base.font?.ascender ?? 0).follow(label.lx.topAnchor.insettedBy(label.lx.base.font?.ascender ?? 0))
        return self
    }
    
    @discardableResult
    public func alignToLastBaseline<T: LayoutingCompatible>(ofSingleLineFittedLabel label: T) -> Layouting<Base> where T.CompatibleType: LayoutableWithFont {
        
        bottomAnchor.insettedBy(base.font?.descender ?? 0).follow(label.lx.topAnchor.insettedBy(label.lx.base.font?.descender ?? 0))
        return self
    }
    
    @discardableResult
    public func setHeightAsLineHeight() -> Layouting<Base>  {
        return set(height: base.font?.lineHeight ?? 0 )
    }
    
}

#if os(macOS)
    extension NSFont {
        var lineHeight: CGFloat {
            #if swift(>=4.2)
                return ceil(ascender + abs(descender) + leading)
            #else
                return ceil(ascender + fabs(descender) + leading)
            #endif
            
        }
    }
#endif
