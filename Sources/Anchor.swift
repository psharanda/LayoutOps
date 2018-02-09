//
//  Created by Pavel Sharanda on 04.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

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
            return rect.maxY - baselinable.baselineValueOfType(baselineType, size: rect.size) - inset
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


extension Layouting where Base: Layoutable {
    
    public var topAnchor: VAnchor {
        return VAnchorType.top(base, 0)
    }
    
    public var vcenterAnchor: VAnchor {
        return VAnchorType.center(base, 0)
    }
    
    public var bottomAnchor: VAnchor {
        return VAnchorType.bottom(base, 0)
    }
    
    public var leftAnchor: HAnchor {
        return HAnchorType.left(base, 0)
    }
    
    public var hcenterAnchor: HAnchor {
        return HAnchorType.center(base, 0)
    }
    
    public var rightAnchor: HAnchor {
        return HAnchorType.right(base, 0)
    }
    
    public var widthAnchor: SizeAnchor {
        return WidthAnchorType(view: base, inset: 0)
    }
    
    public var heightAnchor: SizeAnchor {
        return HeightAnchorType(view: base, inset: 0)
    }
}

extension Layouting where Base: Layoutable, Base: Baselinable {
    
    public var firstBaselineAnchor: VAnchor {
        return VAnchorType.baseline(base, base, .first, 0)
    }
    
    public var lastBaselineAnchor: VAnchor {
        return VAnchorType.baseline(base, base, .last, 0)
    }
}

