//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//


import UIKit

struct UIScreenCache {
    static let scale = UIScreen.main.scale;
}

private extension CGFloat {
    
    
    var pixelPerfect: CGFloat {
        let scale = UIScreenCache.scale
        return (self * scale).rounded()/scale;
    }
    
    var ceilPixelPerfect: CGFloat {
        let scale = UIScreenCache.scale
        return ceil(self * scale)/scale;
    }
}

public typealias ViewLayoutMap = [UIView: CGRect]

//MARK: - LayoutOperation

public protocol LayoutOperation {
    func calculateLayouts(_ layouts: inout ViewLayoutMap, viewport: Viewport)
}

public extension LayoutOperation {
    func layout() {
        
        var layoutsMap = ViewLayoutMap()
        calculateLayouts(&layoutsMap, viewport: Viewport())
        layoutsMap.forEach { view, frame in
            view.frame = CGRect(x: frame.origin.x.pixelPerfect, y: frame.origin.y.pixelPerfect, width: frame.size.width.ceilPixelPerfect, height: frame.size.height.ceilPixelPerfect)
        }
    }
    
    func preciseLayout() {
        var layoutsMap = ViewLayoutMap()
        calculateLayouts(&layoutsMap, viewport: Viewport())
        layoutsMap.forEach { view, frame in
            view.frame = frame
        }
    }
    
    func when(_ condition: (Void) -> Bool) -> LayoutOperation {
        if condition() {
            return self
        } else {
            return NoLayoutOperation()
        }
    }
}

extension LayoutOperation {
    func frameForView(_ view: UIView, layouts: inout ViewLayoutMap) -> CGRect {
        if let r = layouts[view] {
            return r
        } else {
            layouts[view] = view.frame
            return view.frame
        }
    }
}

//MARK: - NOOP

private struct NoLayoutOperation: LayoutOperation {
    
    func calculateLayouts(_ layouts: inout ViewLayoutMap, viewport: Viewport) {
        
    }
}

public func NOOP() -> LayoutOperation {
    return NoLayoutOperation()
}
