//
//  Created by Pavel Sharanda on 27.01.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

public protocol Layoutable: class {
    var lx_parent: Layoutable? {get}
    var lx_bounds: CGRect {get}
    var lx_frame: CGRect {get set}
    var lx_viewport: CGRect? {get set}
    func lx_sizeThatFits(_ size: CGSize) -> CGSize
}

extension Layoutable {
    func updateFrame(_ newValue: CGRect) {
        lx_frame = CGRect(x: newValue.origin.x.pixelPerfect, y: newValue.origin.y.pixelPerfect, width: newValue.size.width.ceilPixelPerfect, height: newValue.size.height.ceilPixelPerfect)
    }
    
    var boundsOrViewPort: CGRect {
        return lx_viewport ?? lx_bounds
    }
}

public struct Layouting<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol LayoutingCompatible: class {
    associatedtype CompatibleType
    // lx stands for Layout eXtensions
    var lx: Layouting<CompatibleType> { get set }
}

extension LayoutingCompatible {
    public var lx: Layouting<Self> {
        get {
            return Layouting(self)
        }
        set {
            // this enables using Layouting to "mutate" base object
        }
    }
}
