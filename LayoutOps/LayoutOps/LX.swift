//
//  Created by Pavel Sharanda on 27.01.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation


struct UIScreenCache {
    static let scale = UIScreen.mainScreen().scale;
}

extension CGFloat {
    
    var pixelPerfect: CGFloat {
        let scale = UIScreenCache.scale
        return round(self * scale)/scale;
    }
    
    var ceilPixelPerfect: CGFloat {
        let scale = UIScreenCache.scale
        return ceil(self * scale)/scale;
    }
}

public protocol Layoutable: class {
    var parent: Layoutable? {get}
    var bounds: CGRect {get}
    var frame: CGRect {get set}
    func sizeThatFits(size: CGSize) -> CGSize
}

extension Layoutable {
    func updateFrame(newValue: CGRect) {
        frame = CGRect(x: newValue.origin.x.pixelPerfect, y: newValue.origin.y.pixelPerfect, width: newValue.size.width.ceilPixelPerfect, height: newValue.size.height.ceilPixelPerfect)
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
