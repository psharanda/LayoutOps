//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//


import UIKit

struct UIScreenCache {
    static let scale = UIScreen.mainScreen().scale;
}

private extension CGFloat {
    
    
    var pixelPerfect: CGFloat {
        let scale = UIScreenCache.scale
        return round(self * scale)/scale;
    }
    
    var ceilPixelPerfect: CGFloat {
        let scale = UIScreenCache.scale
        return ceil(self * scale)/scale;
    }
}

//public struct ViewLayoutMap {
//    
//    private var dict = [Int: CGRect]()
//    private var set = [UIView]()
//    
//    func forEach(f: (UIView, CGRect) -> Void) {
////         Set(set).forEach { value in
////            f(value, dict[value.hashValue]!)
////        }
//    }
//    
//    subscript(key: UIView) -> CGRect? {
//        get {
//            return key.frame
//        }
//        
//        set {
//            if let newValue = newValue {
//                key.frame = newValue
//            }
//        }
//    }
//}

public typealias ViewLayoutMap = [UIView: CGRect]

//MARK: - LayoutOperation

public protocol LayoutOperation {
    func calculateLayouts(inout layouts: ViewLayoutMap, viewport: Viewport)
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
    
    func when(condition: (Void) -> Bool) -> LayoutOperation {
        if condition() {
            return self
        } else {
            return NoLayoutOperation()
        }
    }
}

extension LayoutOperation {
    func frameForView(view: UIView, inout layouts: ViewLayoutMap) -> CGRect {
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
    
    func calculateLayouts(inout layouts: ViewLayoutMap, viewport: Viewport) {
        
    }
}

public func NOOP() -> LayoutOperation {
    return NoLayoutOperation()
}
