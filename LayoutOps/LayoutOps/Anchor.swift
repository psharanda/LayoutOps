//
//  Anchor.swift
//  LayoutOps
//
//  Created by Pavel Sharanda on 04.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

public protocol Anchor {
    func valueForRect(_ rect: CGRect) -> CGFloat
    func setValueForRect(_ value: CGFloat, rect: CGRect) -> CGRect    
    var view: Layoutable {get}
}

extension Anchor {
    func anchorValue(_ layouts: ViewLayoutMap) -> CGFloat? {
        return layouts[view].flatMap {  valueForRect($0) }
    }
}

//MARK: - hanchor

public protocol HAnchor: Anchor {
    
}

private enum HAnchorType : HAnchor {

    case left(Layoutable, CGFloat)
    case center(Layoutable, CGFloat)
    case right(Layoutable, CGFloat)
    
    func valueForRect(_ rect: CGRect) -> CGFloat {
        switch self {
        case .left(_, let inset):
            return rect.minX + inset
        case .right(_, let inset):
            return rect.maxX + inset
        case .center(_, let inset):
            return rect.midX + inset
        }
    }
    
    func setValueForRect(_ value: CGFloat, rect: CGRect) -> CGRect {
        var result = rect
        switch self {
        case .left(_, let inset):
            result.origin.x = value - inset
        case .right(_, let inset):
            result.origin.x = value - result.size.width - inset
        case .center(_, let inset):
            result.origin.x = value - result.size.width/2 - inset
        }
        
        return result
    }
    
    var view: Layoutable {
        switch self {
        case .left(let v, _):
            return v
        case .right(let v, _):
            return v
        case .center(let v, _):
            return v
        }
    }
}


public func LeftAnchor(_ view: Layoutable, inset: CGFloat) -> HAnchor {
    return HAnchorType.left(view, inset)
}

public func LeftAnchor(_ view: Layoutable) -> HAnchor {
    return LeftAnchor(view, inset: 0)
}

public func RightAnchor(_ view: Layoutable, inset: CGFloat) -> HAnchor {
    return HAnchorType.right(view, inset)
}

public func RightAnchor(_ view: Layoutable) -> HAnchor {
    return RightAnchor(view, inset: 0)
}


public func HCenterAnchor(_ view: Layoutable, inset: CGFloat) -> HAnchor {
    return HAnchorType.center(view, inset)
}

public func HCenterAnchor(_ view: Layoutable) -> HAnchor {
    return HCenterAnchor(view, inset: 0)
}

//MARK: - Baselinable
public protocol Baselinable {
    func baselineValueOfType(_ type: BaselineType, size: CGSize) -> CGFloat
}

//MARK: - vanchor

public protocol VAnchor: Anchor {
    
}

private enum VAnchorType : VAnchor {
    case top(Layoutable, CGFloat)
    case bottom(Layoutable, CGFloat)
    case center(Layoutable, CGFloat)
    case baseline(Layoutable, Baselinable, BaselineType, CGFloat)
    
    func valueForRect(_ rect: CGRect) -> CGFloat {
        switch self {
        case .top(_, let inset):
            return rect.minY + inset
        case .bottom(_, let inset):
            return rect.maxY + inset
        case .center(_, let inset):
            return rect.midY + inset
        case .baseline(_, let baselinable, let baselineType, let inset):
            return rect.origin.y + baselinable.baselineValueOfType(baselineType, size: rect.size) + inset
        }
    }
    
    func setValueForRect(_ value: CGFloat, rect: CGRect) -> CGRect {
        
        var result = rect
        
        switch self {
        case .top(_, let inset):
            result.origin.y = value - inset
        case .bottom(_, let inset):
            result.origin.y = value - result.size.height - inset
        case .center(_, let inset):
            result.origin.y = value - result.size.height/2 - inset
        case .baseline(_, let baselinable, let baselineType, let inset):
            result.origin.y = value - baselinable.baselineValueOfType(baselineType, size: result.size) - inset
        }
        
        return result
    }
    
    var view: Layoutable {
        switch self {
        case .top(let v, _):
            return v
        case .bottom(let v, _):
            return v
        case .center(let v, _):
            return v
        case .baseline(let v, _, _, _):
            return v
        }
    }
}

public func TopAnchor(_ view: Layoutable, inset: CGFloat) -> VAnchor {
    return VAnchorType.top(view, inset)
}

public func TopAnchor(_ view: Layoutable) -> VAnchor {
    return TopAnchor(view, inset: 0)
}

public func BottomAnchor(_ view: Layoutable, inset: CGFloat) -> VAnchor {
    return VAnchorType.bottom(view, inset)
}

public func BottomAnchor(_ view: Layoutable) -> VAnchor {
    return BottomAnchor(view, inset: 0)
}


public func VCenterAnchor(_ view: Layoutable, inset: CGFloat) -> VAnchor {
    return VAnchorType.center(view, inset)
}

public func VCenterAnchor(_ view: Layoutable) -> VAnchor {
    return VCenterAnchor(view, inset: 0)
}

public enum BaselineType {
    case first
    case last
}

public func BaselineAnchor<T: Layoutable>(_ view: T, type: BaselineType, inset: CGFloat) -> VAnchor where T: Baselinable {
    return VAnchorType.baseline(view, view, type, inset)
}

public func BaselineAnchor<T: Layoutable>(_ view: T, type: BaselineType) -> VAnchor where T: Baselinable {
    return VAnchorType.baseline(view, view, type, 0)
}

public func BaselineAnchor<T: Layoutable>(_ view: T) -> VAnchor where T: Baselinable {
    return VAnchorType.baseline(view, view, .first, 0)
}

public protocol SizeAnchor: Anchor {
    
}

struct WidthAnchorType: SizeAnchor {
    let view: Layoutable
    let inset: CGFloat
    init(view: Layoutable, inset: CGFloat) {
        self.view = view
        self.inset = inset
    }
    
    func valueForRect(_ rect: CGRect) -> CGFloat {
        return rect.width + inset
    }
    
    func setValueForRect(_ value: CGFloat, rect: CGRect) -> CGRect {
        var result = rect
        result.size.width = value - inset
        return result
    }
}

public func WidthAnchor(_ view: Layoutable, inset: CGFloat) -> SizeAnchor {
    return WidthAnchorType(view: view, inset: inset)
}

public func WidthAnchor(_ view: Layoutable) -> SizeAnchor {
    return WidthAnchorType(view: view, inset: 0)
}

struct HeightAnchorType: SizeAnchor {
    let view: Layoutable
    let inset: CGFloat
    init(view: Layoutable, inset: CGFloat) {
        self.view = view
        self.inset = inset
    }
    
    func valueForRect(_ rect: CGRect) -> CGFloat {
        return rect.height + inset
    }
    
    func setValueForRect(_ value: CGFloat, rect: CGRect) -> CGRect {
        var result = rect
        result.size.height = value - inset
        return result
    }
}

public func HeightAnchor(_ view: Layoutable, inset: CGFloat) -> SizeAnchor {
    return HeightAnchorType(view: view, inset: inset)
}

public func HeightAnchor(_ view: Layoutable) -> SizeAnchor {
    return HeightAnchorType(view: view, inset: 0)
}



