//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//


import UIKit

struct UIScreenCache {
    static let scale = UIScreen.main.scale;
}

extension CGFloat {

    var pixelPerfect: CGFloat {
        let scale = UIScreenCache.scale
        return ((self * scale)/scale).rounded();
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
    func sizeThatFits(_ size: CGSize) -> CGSize
}

extension Layoutable {
    fileprivate var addressHash: Int { return Unmanaged.passUnretained(self).toOpaque().hashValue }
}

struct LayoutBox: Hashable {
    let layoutable: Layoutable
    init(layoutable: Layoutable) {
        self.layoutable = layoutable
    }
    
    var hashValue: Int {
        return layoutable.addressHash
    }
}

func ==(lhs: LayoutBox, rhs: LayoutBox) -> Bool {
    return lhs.layoutable === rhs.layoutable
}

public struct ViewLayoutMap {
    
    fileprivate var map = [LayoutBox: CGRect]()
    
    
    func forEach(_ f: (Layoutable, CGRect) -> Void) {
        map.forEach{
            f($0.0.layoutable, $0.1)
        }
    }
    
    subscript(key: Layoutable) -> CGRect? {
        get {
            return map[LayoutBox(layoutable: key)]
        }
        
        set {
            map[LayoutBox(layoutable: key)] = newValue
        }
    }
}

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
    func frameForView(_ view: Layoutable, layouts: inout ViewLayoutMap) -> CGRect {
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
