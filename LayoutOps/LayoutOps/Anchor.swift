//
//  Anchor.swift
//  LayoutOps
//
//  Created by Pavel Sharanda on 04.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

/************************************************************************************/
/*[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]*/
/************************************************************************************/

public protocol Anchor {
    func valueForRect(rect: CGRect) -> CGFloat
    func setValueForRect(value: CGFloat, rect: CGRect) -> CGRect
    var view: Layoutable {get}
    
    func insettedBy(value: CGFloat) -> Self
}

extension Anchor {
    func anchorValue(layouts: ViewLayoutMap) -> CGFloat? {
        return layouts[view].flatMap {  valueForRect($0) }
    }
}

//MARK: - hanchor

public protocol HAnchor: Anchor {
    
}

private enum HAnchorType : HAnchor {
    
    case Left(Layoutable, CGFloat)
    case Center(Layoutable, CGFloat)
    case Right(Layoutable, CGFloat)
    
    func valueForRect(rect: CGRect) -> CGFloat {
        switch self {
        case .Left(_, let inset):
            return CGRectGetMinX(rect) + inset
        case .Right(_, let inset):
            return CGRectGetMaxX(rect) + inset
        case .Center(_, let inset):
            return CGRectGetMidX(rect) + inset
        }
    }
    
    func setValueForRect(value: CGFloat, rect: CGRect) -> CGRect {
        var result = rect
        switch self {
        case .Left(_, let inset):
            result.origin.x = value - inset
        case .Right(_, let inset):
            result.origin.x = value - result.size.width - inset
        case .Center(_, let inset):
            result.origin.x = value - result.size.width/2 - inset
        }
        
        return result
    }
    
    var view: Layoutable {
        switch self {
        case .Left(let v, _):
            return v
        case .Right(let v, _):
            return v
        case .Center(let v, _):
            return v
        }
    }
    
    private func insettedBy(value: CGFloat) -> HAnchorType {
        switch self {
        case .Left(let view, let inset):
            return .Left(view, inset + value)
        case .Right(let view, let inset):
            return .Right(view, inset + value)
        case .Center(let view, let inset):
            return .Center(view, inset + value)
        }
    }
}


public func LeftAnchor(view: Layoutable, inset: CGFloat) -> HAnchor {
    return HAnchorType.Left(view, inset)
}

public func LeftAnchor(view: Layoutable) -> HAnchor {
    return LeftAnchor(view, inset: 0)
}

public func RightAnchor(view: Layoutable, inset: CGFloat) -> HAnchor {
    return HAnchorType.Right(view, inset)
}

public func RightAnchor(view: Layoutable) -> HAnchor {
    return RightAnchor(view, inset: 0)
}


public func HCenterAnchor(view: Layoutable, inset: CGFloat) -> HAnchor {
    return HAnchorType.Center(view, inset)
}

public func HCenterAnchor(view: Layoutable) -> HAnchor {
    return HCenterAnchor(view, inset: 0)
}

//MARK: - Baselinable
public protocol Baselinable {
    func baselineValueOfType(type: BaselineType, size: CGSize) -> CGFloat
}

//MARK: - vanchor

public protocol VAnchor: Anchor {
    
}

private enum VAnchorType : VAnchor {
    case Top(Layoutable, CGFloat)
    case Bottom(Layoutable, CGFloat)
    case Center(Layoutable, CGFloat)
    case Baseline(Layoutable, Baselinable, BaselineType, CGFloat)
    
    func valueForRect(rect: CGRect) -> CGFloat {
        switch self {
        case .Top(_, let inset):
            return CGRectGetMinY(rect) + inset
        case .Bottom(_, let inset):
            return CGRectGetMaxY(rect) + inset
        case .Center(_, let inset):
            return CGRectGetMidY(rect) + inset
        case .Baseline(_, let baselinable, let baselineType, let inset):
            return rect.origin.y + baselinable.baselineValueOfType(baselineType, size: rect.size) + inset
        }
    }
    
    func setValueForRect(value: CGFloat, rect: CGRect) -> CGRect {
        
        var result = rect
        
        switch self {
        case .Top(_, let inset):
            result.origin.y = value - inset
        case .Bottom(_, let inset):
            result.origin.y = value - result.size.height - inset
        case .Center(_, let inset):
            result.origin.y = value - result.size.height/2 - inset
        case .Baseline(_, let baselinable, let baselineType, let inset):
            result.origin.y = value - baselinable.baselineValueOfType(baselineType, size: result.size) - inset
        }
        
        return result
    }
    
    var view: Layoutable {
        switch self {
        case .Top(let v, _):
            return v
        case .Bottom(let v, _):
            return v
        case .Center(let v, _):
            return v
        case .Baseline(let v, _, _, _):
            return v
        }
    }
    
    private func insettedBy(value: CGFloat) -> VAnchorType {
        switch self {
        case .Top(let view, let inset):
            return .Top(view, inset + value)
        case .Bottom(let view, let inset):
            return .Bottom(view, inset + value)
        case .Center(let view, let inset):
            return .Center(view, inset + value)
        case .Baseline(let view, let baselinable, let baselineType, let inset):
            return .Baseline(view, baselinable, baselineType, inset + value)
        }
    }
}

public func TopAnchor(view: Layoutable, inset: CGFloat) -> VAnchor {
    return VAnchorType.Top(view, inset)
}

public func TopAnchor(view: Layoutable) -> VAnchor {
    return TopAnchor(view, inset: 0)
}

public func BottomAnchor(view: Layoutable, inset: CGFloat) -> VAnchor {
    return VAnchorType.Bottom(view, inset)
}

public func BottomAnchor(view: Layoutable) -> VAnchor {
    return BottomAnchor(view, inset: 0)
}


public func VCenterAnchor(view: Layoutable, inset: CGFloat) -> VAnchor {
    return VAnchorType.Center(view, inset)
}

public func VCenterAnchor(view: Layoutable) -> VAnchor {
    return VCenterAnchor(view, inset: 0)
}

public enum BaselineType {
    case First
    case Last
}

public func BaselineAnchor<T: Layoutable where T: Baselinable>(view: T, type: BaselineType, inset: CGFloat) -> VAnchor {
    return VAnchorType.Baseline(view, view, type, inset)
}

public func BaselineAnchor<T: Layoutable where T: Baselinable>(view: T, type: BaselineType) -> VAnchor {
    return VAnchorType.Baseline(view, view, type, 0)
}

public func BaselineAnchor<T: Layoutable where T: Baselinable>(view: T) -> VAnchor {
    return VAnchorType.Baseline(view, view, .First, 0)
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
    
    func valueForRect(rect: CGRect) -> CGFloat {
        return rect.width + inset
    }
    
    func setValueForRect(value: CGFloat, rect: CGRect) -> CGRect {
        var result = rect
        result.size.width = value - inset
        return result
    }
    
    func insettedBy(value: CGFloat) -> WidthAnchorType {
        return WidthAnchorType(view: view, inset: inset + value)
    }
    
}

public func WidthAnchor(view: Layoutable, inset: CGFloat) -> SizeAnchor {
    return WidthAnchorType(view: view, inset: inset)
}

public func WidthAnchor(view: Layoutable) -> SizeAnchor {
    return WidthAnchorType(view: view, inset: 0)
}

struct HeightAnchorType: SizeAnchor {
    let view: Layoutable
    let inset: CGFloat
    init(view: Layoutable, inset: CGFloat) {
        self.view = view
        self.inset = inset
    }
    
    func valueForRect(rect: CGRect) -> CGFloat {
        return rect.height + inset
    }
    
    func setValueForRect(value: CGFloat, rect: CGRect) -> CGRect {
        var result = rect
        result.size.height = value - inset
        return result
    }
    
    func insettedBy(value: CGFloat) -> HeightAnchorType {
        return HeightAnchorType(view: view, inset: inset + value)
    }
}

public func HeightAnchor(view: Layoutable, inset: CGFloat) -> SizeAnchor {
    return HeightAnchorType(view: view, inset: inset)
}

public func HeightAnchor(view: Layoutable) -> SizeAnchor {
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
    
    var firstBaselineAnchor: VAnchor {
        return BaselineAnchor(base, type: .First)
    }
    
    var lastBaselineAnchor: VAnchor {
        return BaselineAnchor(base, type: .Last)
    }
}



