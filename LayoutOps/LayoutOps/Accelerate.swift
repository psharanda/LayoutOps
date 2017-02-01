//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

//some common, but very specific ops

public protocol LayoutableWithFont: Layoutable {
    var font: UIFont! {get}
}

extension Layouting where Base: Layoutable, Base: LayoutableWithFont {
    
    public func alignToFirstBaseline<T: LayoutingCompatible where T: LayoutableWithFont>(ofSingleLineFittedLabel label: T) -> Layouting<Base> {
        topAnchor.insettedBy(base.font?.ascender ?? 0).follow(label.lx.topAnchor.insettedBy(label.lx.base.font?.ascender ?? 0))
        return self
    }
    
    public func alignToLastBaseline<T: LayoutingCompatible where T.CompatibleType: LayoutableWithFont>(ofSingleLineFittedLabel label: T) -> Layouting<Base> {
        
        bottomAnchor.insettedBy(base.font?.descender ?? 0).follow(label.lx.topAnchor.insettedBy(label.lx.base.font?.descender ?? 0))
        return self
    }
    
    public func setHeightAsLineHeight() -> Layouting<Base>  {
        return set(height: base.font?.lineHeight ?? 0)
    }
    
}