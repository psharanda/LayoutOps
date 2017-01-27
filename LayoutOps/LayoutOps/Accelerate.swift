//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

//some common, but very specific ops

public protocol LayoutableWithFont: Layoutable {
    var font: UIFont! {get}
}

public func AlignFittedLabelsUsingFirstBaseline(_ label1: LayoutableWithFont, _ label2: LayoutableWithFont) -> LayoutOperation {
    return Follow(TopAnchor(label1, inset: label1.font?.ascender ?? 0), withAnchor: TopAnchor(label2, inset: label2.font?.ascender ?? 0))
}

public func AlignFittedLabelsUsingLastBaseline(_ label1: LayoutableWithFont, _ label2: LayoutableWithFont) -> LayoutOperation {
    return Follow(BottomAnchor(label1, inset: label1.font?.descender ?? 0), withAnchor: BottomAnchor(label2, inset: label2.font?.descender ?? 0))
}

public func SetHeightAsLineHeight(_ label: LayoutableWithFont) -> LayoutOperation {
    return SetHeight(label, value: label.font?.lineHeight ?? 0)
}
