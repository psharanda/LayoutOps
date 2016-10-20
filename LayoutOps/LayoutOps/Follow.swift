//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit


public protocol Anchor {
    func valueForRect(rect: CGRect) -> CGFloat
    func setValueForRect(value: CGFloat, rect: CGRect) -> CGRect
    
    var view: UIView {get}
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

//MARK: - follow

private struct FollowOperation: LayoutOperation {
    
    let anchorToFollow: Anchor
    let followerAnchor: Anchor
    
    func calculateLayouts(inout layouts: ViewLayoutMap, viewport: Viewport) {
        
        let toFollowView = anchorToFollow.view
        let followerView = followerAnchor.view
        
        if(toFollowView.superview != followerView.superview) {
            print("[LayoutOps:WARNING] Follow operation will produce undefined results for views with different superview")
            print("View to follow: \(toFollowView)")
            print("Follower view: \(followerView)")
        }
        
        let anchorToFollowFrame = frameForView(toFollowView, layouts: &layouts)
        let followerAnchorFrame = frameForView(followerView, layouts: &layouts)
        
        layouts[followerView] = followerAnchor.setValueForRect(anchorToFollow.valueForRect(anchorToFollowFrame), rect: followerAnchorFrame)
    }
    
    init(anchorToFollow: Anchor, followerAnchor: Anchor) {
        self.anchorToFollow = anchorToFollow
        self.followerAnchor = followerAnchor
    }
    
}

// anchor.value + inset = withAnchor.value + inset

public func Follow(anchor: HAnchor, withAnchor: HAnchor) -> LayoutOperation {
    return FollowOperation(anchorToFollow: anchor, followerAnchor: withAnchor)
}

public func Follow(anchor: VAnchor, withAnchor: VAnchor) -> LayoutOperation {
    return FollowOperation(anchorToFollow: anchor, followerAnchor: withAnchor)
}

public func FollowCenter(ofView: UIView, dx dx1: CGFloat, dy dy1: CGFloat, withView: UIView, dx dx2: CGFloat, dy dy2: CGFloat) -> LayoutOperation {
    return Combine([
        Follow(HCenterAnchor(ofView, inset: dx1), withAnchor: HCenterAnchor(withView, inset: dx2)),
        Follow(VCenterAnchor(ofView, inset: dy1), withAnchor: VCenterAnchor(withView, inset: dy2))
    ])
}

public func FollowCenter(ofView: UIView, withView: UIView) -> LayoutOperation {
    return FollowCenter(ofView, dx: 0, dy: 0, withView: withView, dx: 0, dy: 0)
}


public protocol Baselinable {
    func baselineValueOfType(type: BaselineType, size: CGSize) -> CGFloat
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