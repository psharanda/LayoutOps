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

public enum LX {
    public func alignFittedLabelsUsingFirstBaseline<T: LayoutingCompatible where T.CompatibleType: LayoutableWithFont>(label1: T, _ label2: T) {
        label2.lx.topAnchor.insettedBy(label2.lx.base.font?.ascender ?? 0).follow(label1.lx.topAnchor.insettedBy(label1.lx.base.font?.ascender ?? 0))
    }
    
    public func alignFittedLabelsUsingLastBaseline<T: LayoutingCompatible where T.CompatibleType: LayoutableWithFont>(label1: T, _ label2: T) {
        
        label2.lx.bottomAnchor.insettedBy(label2.lx.base.font?.descender ?? 0).follow(label1.lx.bottomAnchor.insettedBy(label1.lx.base.font?.descender ?? 0))
    }
    
    public func setHeightAsLineHeight<T: LayoutingCompatible where T.CompatibleType: LayoutableWithFont>(label: T) {
        label.lx.setHeight(label.lx.base.font?.lineHeight ?? 0)
    }
}