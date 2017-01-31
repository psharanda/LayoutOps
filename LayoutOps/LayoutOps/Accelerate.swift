//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

//some common, but very specific ops

public protocol LayoutableWithFont: Layoutable {
    var font: UIFont! {get}
}

public func AlignFittedLabelsUsingFirstBaseline(label1: LayoutableWithFont, _ label2: LayoutableWithFont) -> LayoutOperation {
    return Follow(TopAnchor(label1, inset: label1.font?.ascender ?? 0), withAnchor: TopAnchor(label2, inset: label2.font?.ascender ?? 0))
}

public func AlignFittedLabelsUsingLastBaseline(label1: LayoutableWithFont, _ label2: LayoutableWithFont) -> LayoutOperation {
    return Follow(BottomAnchor(label1, inset: label1.font?.descender ?? 0), withAnchor: BottomAnchor(label2, inset: label2.font?.descender ?? 0))
}

public func SetHeightAsLineHeight(label: LayoutableWithFont) -> LayoutOperation {
    return SetHeight(label, value: label.font?.lineHeight ?? 0)
}

/************************************************************************************/
/*[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]*/
/************************************************************************************/


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