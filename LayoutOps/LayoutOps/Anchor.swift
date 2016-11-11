//
//  Anchor.swift
//  LayoutOps
//
//  Created by Pavel Sharanda on 04.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

public protocol Anchor {
    func valueForRect(rect: CGRect) -> CGFloat
    func setValueForRect(value: CGFloat, rect: CGRect) -> CGRect    
    var view: UIView {get}
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

    case Left(UIView, CGFloat)
    case Center(UIView, CGFloat)
    case Right(UIView, CGFloat)
    
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
    
    var view: UIView {
        switch self {
        case .Left(let v, _):
            return v
        case .Right(let v, _):
            return v
        case .Center(let v, _):
            return v
        }
    }
}


public func LeftAnchor(view: UIView, inset: CGFloat) -> HAnchor {
    return HAnchorType.Left(view, inset)
}

public func LeftAnchor(view: UIView) -> HAnchor {
    return LeftAnchor(view, inset: 0)
}

public func RightAnchor(view: UIView, inset: CGFloat) -> HAnchor {
    return HAnchorType.Right(view, inset)
}

public func RightAnchor(view: UIView) -> HAnchor {
    return RightAnchor(view, inset: 0)
}


public func HCenterAnchor(view: UIView, inset: CGFloat) -> HAnchor {
    return HAnchorType.Center(view, inset)
}

public func HCenterAnchor(view: UIView) -> HAnchor {
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
    case Top(UIView, CGFloat)
    case Bottom(UIView, CGFloat)
    case Center(UIView, CGFloat)
    case Baseline(UIView, Baselinable, BaselineType, CGFloat)
    
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
    
    var view: UIView {
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
}

public func TopAnchor(view: UIView, inset: CGFloat) -> VAnchor {
    return VAnchorType.Top(view, inset)
}

public func TopAnchor(view: UIView) -> VAnchor {
    return TopAnchor(view, inset: 0)
}

public func BottomAnchor(view: UIView, inset: CGFloat) -> VAnchor {
    return VAnchorType.Bottom(view, inset)
}

public func BottomAnchor(view: UIView) -> VAnchor {
    return BottomAnchor(view, inset: 0)
}


public func VCenterAnchor(view: UIView, inset: CGFloat) -> VAnchor {
    return VAnchorType.Center(view, inset)
}

public func VCenterAnchor(view: UIView) -> VAnchor {
    return VCenterAnchor(view, inset: 0)
}

public enum BaselineType {
    case First
    case Last
}

public func BaselineAnchor<T: UIView where T: Baselinable>(view: T, type: BaselineType, inset: CGFloat) -> VAnchor {
    return VAnchorType.Baseline(view, view, type, inset)
}

public func BaselineAnchor<T: UIView where T: Baselinable>(view: T, type: BaselineType) -> VAnchor {
    return VAnchorType.Baseline(view, view, type, 0)
}

public func BaselineAnchor<T: UIView where T: Baselinable>(view: T) -> VAnchor {
    return VAnchorType.Baseline(view, view, .First, 0)
}

public protocol SizeAnchor: Anchor {
    
}

struct WidthAnchorType: SizeAnchor {
    let view: UIView
    let inset: CGFloat
    init(view: UIView, inset: CGFloat) {
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
}

public func WidthAnchor(view: UIView, inset: CGFloat) -> SizeAnchor {
    return WidthAnchorType(view: view, inset: inset)
}

public func WidthAnchor(view: UIView) -> SizeAnchor {
    return WidthAnchorType(view: view, inset: 0)
}

struct HeightAnchorType: SizeAnchor {
    let view: UIView
    let inset: CGFloat
    init(view: UIView, inset: CGFloat) {
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
}

public func HeightAnchor(view: UIView, inset: CGFloat) -> SizeAnchor {
    return HeightAnchorType(view: view, inset: inset)
}

public func HeightAnchor(view: UIView) -> SizeAnchor {
    return HeightAnchorType(view: view, inset: 0)
}



extension UILabel: Baselinable {
    public func baselineValueOfType(type: BaselineType, size: CGSize) -> CGFloat {
        let sz = sizeThatFits(size)
        
        switch type {
        case .First:
            return (size.height - sz.height)/2 + font.ascender
        case .Last:
            return size.height - (size.height - sz.height)/2 + font.descender
        }
    }
}
