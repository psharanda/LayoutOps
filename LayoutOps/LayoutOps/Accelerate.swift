//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

//some common, but very specific ops

public protocol LayoutableWithFont: Layoutable {
    var font: UIFont! {get}
}

extension Layouting where Base: Layoutable, Base: LayoutableWithFont {
    
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
        return set(height: base.font?.lineHeight ?? 0)
    }
    
}
