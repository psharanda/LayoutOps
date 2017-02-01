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
    
    func insettedBy(_ value: CGFloat) -> Self
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
    
    fileprivate func insettedBy(_ value: CGFloat) -> HAnchorType {
        switch self {
        case .left(let view, let inset):
            return .left(view, inset + value)
        case .right(let view, let inset):
            return .right(view, inset + value)
        case .center(let view, let inset):
            return .center(view, inset + value)
        }
    }
}


private func LeftAnchor(_ view: Layoutable, inset: CGFloat) -> HAnchor {
    return HAnchorType.left(view, inset)
}

private func LeftAnchor(_ view: Layoutable) -> HAnchor {
    return LeftAnchor(view, inset: 0)
}

private func RightAnchor(_ view: Layoutable, inset: CGFloat) -> HAnchor {
    return HAnchorType.right(view, inset)
}

private func RightAnchor(_ view: Layoutable) -> HAnchor {
    return RightAnchor(view, inset: 0)
}


private func HCenterAnchor(_ view: Layoutable, inset: CGFloat) -> HAnchor {
    return HAnchorType.center(view, inset)
}

private func HCenterAnchor(_ view: Layoutable) -> HAnchor {
    return HCenterAnchor(view, inset: 0)
}

public enum BaselineType {
    case first
    case last
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
    
    fileprivate func insettedBy(_ value: CGFloat) -> VAnchorType {
        switch self {
        case .top(let view, let inset):
            return .top(view, inset + value)
        case .bottom(let view, let inset):
            return .bottom(view, inset + value)
        case .center(let view, let inset):
            return .center(view, inset + value)
        case .baseline(let view, let baselinable, let baselineType, let inset):
            return .baseline(view, baselinable, baselineType, inset + value)
        }
    }
}

private func TopAnchor(_ view: Layoutable, inset: CGFloat) -> VAnchor {
    return VAnchorType.top(view, inset)
}

private func TopAnchor(_ view: Layoutable) -> VAnchor {
    return TopAnchor(view, inset: 0)
}

private func BottomAnchor(_ view: Layoutable, inset: CGFloat) -> VAnchor {
    return VAnchorType.bottom(view, inset)
}

private func BottomAnchor(_ view: Layoutable) -> VAnchor {
    return BottomAnchor(view, inset: 0)
}


private func VCenterAnchor(_ view: Layoutable, inset: CGFloat) -> VAnchor {
    return VAnchorType.center(view, inset)
}

private func VCenterAnchor(_ view: Layoutable) -> VAnchor {
    return VCenterAnchor(view, inset: 0)
}



private func BaselineAnchor<T: Layoutable>(_ view: T, type: BaselineType, inset: CGFloat) -> VAnchor where T: Baselinable {
    return VAnchorType.baseline(view, view, type, inset)
}

private func BaselineAnchor<T: Layoutable>(_ view: T, type: BaselineType) -> VAnchor where T: Baselinable {
    return VAnchorType.baseline(view, view, type, 0)
}

private func BaselineAnchor<T: Layoutable>(_ view: T) -> VAnchor where T: Baselinable {
    return VAnchorType.baseline(view, view, .first, 0)
}

public protocol SizeAnchor: Anchor {
    
}

private struct WidthAnchorType: SizeAnchor {
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
    
    func insettedBy(_ value: CGFloat) -> WidthAnchorType {
        return WidthAnchorType(view: view, inset: inset + value)
    }
    
}

private func WidthAnchor(_ view: Layoutable, inset: CGFloat) -> SizeAnchor {
    return WidthAnchorType(view: view, inset: inset)
}

private func WidthAnchor(_ view: Layoutable) -> SizeAnchor {
    return WidthAnchorType(view: view, inset: 0)
}

private struct HeightAnchorType: SizeAnchor {
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
    
    func insettedBy(_ value: CGFloat) -> HeightAnchorType {
        return HeightAnchorType(view: view, inset: inset + value)
    }
}

private func HeightAnchor(_ view: Layoutable, inset: CGFloat) -> SizeAnchor {
    return HeightAnchorType(view: view, inset: inset)
}

private func HeightAnchor(_ view: Layoutable) -> SizeAnchor {
    return HeightAnchorType(view: view, inset: 0)
}

extension Layouting where Base: Layoutable {
    
    public var topAnchor: VAnchor {
        return TopAnchor(base)
    }
    
    public var vcenterAnchor: VAnchor {
        return VCenterAnchor(base)
    }
    
    public var bottomAnchor: VAnchor {
        return BottomAnchor(base)
    }
    
    public var leftAnchor: HAnchor {
        return LeftAnchor(base)
    }
    
    public var hcenterAnchor: HAnchor {
        return HCenterAnchor(base)
    }
    
    public var rightAnchor: HAnchor {
        return RightAnchor(base)
    }
    
    public var widthAnchor: SizeAnchor {
        return WidthAnchor(base)
    }
    
    public var heightAnchor: SizeAnchor {
        return HeightAnchor(base)
    }
}

extension Layouting where Base: Layoutable, Base: Baselinable {
    
    public var firstBaselineAnchor: VAnchor {
        return BaselineAnchor(base, type: .first)
    }
    
    public var lastBaselineAnchor: VAnchor {
        return BaselineAnchor(base, type: .last)
    }
}



