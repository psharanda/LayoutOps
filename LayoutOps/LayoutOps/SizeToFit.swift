//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public enum SizeToFitIntention {
    /**
     Use defined value
     */
    case Value(CGFloat)
    /**
     Use max value to fully fit content
     */
    case Max
    /**
     Use current frame value to fit content in it
     */
    case Current
    /**
     Use current frame value for fit calculation, but keep it as value for frame
     */
    case KeepCurrent
}

public enum SizeConstraint {
    case Default
    case Min(CGFloat)
    case Max(CGFloat)
    case MinMax(CGFloat, CGFloat)
    
    
    public var minValue: CGFloat {
        switch self {
        case .Default, .Max:
            return CGFloat.min
        case .Min(let min):
            return min
        case .MinMax(let min, _):
            return min
        }
    }
    
    public var maxValue: CGFloat {
        switch self {
        case .Default, .Min:
            return CGFloat.max
        case .Max(let max):
            return max
        case .MinMax(_, let max):
            return max
        }
    }
}

private struct SizeToFitOperation: LayoutOperation {
    let view: Layoutable
    let width: SizeToFitIntention
    let height: SizeToFitIntention
    let widthSizeConstraint: SizeConstraint
    let heightSizeConstraint: SizeConstraint
    
    func calculateLayouts(inout layouts: ViewLayoutMap, viewport: Viewport) {
        
        let fr = frameForView(view, layouts: &layouts)
        
        var w: CGFloat = 0
        switch width {
        case .Value(let val):
            w = val
        case .Max:
            w = CGFloat.max
        case .Current:
            w = fr.width
        case .KeepCurrent:
            w = fr.width
        }
        
        var h: CGFloat = 0
        switch height {
        case .Value(let val):
            h = val
        case .Max:
            h = CGFloat.max
        case .Current:
            h = fr.height
        case .KeepCurrent:
            h = fr.height
        }
        
        var sz = view.sizeThatFits(CGSizeMake(w, h))
        
        
        switch width {
        case .Value(let val):
            sz.width = min(val, sz.width)
        case .Max:
            break
        case .Current:
            break
        case .KeepCurrent:
            sz.width = fr.width
        }
        
        switch height {
        case .Value(let val):
            sz.height = min(val, sz.height)
        case .Max:
            break
        case .Current:
            break
        case .KeepCurrent:
            sz.height = fr.height
        }
        
        sz.width = min(max(widthSizeConstraint.minValue, sz.width), widthSizeConstraint.maxValue)
        sz.height = min(max(heightSizeConstraint.minValue, sz.height), heightSizeConstraint.maxValue)
        
        SetSize(view, width: sz.width, height: sz.height).calculateLayouts(&layouts, viewport: viewport)
    }
}

public func SizeToFit(view: Layoutable, width: SizeToFitIntention, height: SizeToFitIntention, widthConstraint: SizeConstraint = .Default, heightConstraint: SizeConstraint = .Default) -> LayoutOperation {
    return SizeToFitOperation(view: view, width: width, height: height, widthSizeConstraint: widthConstraint, heightSizeConstraint:  heightConstraint)
}

/**
 same as SizeToFit(view, width: .Max, height: .Max)
 */
public func SizeToFitMax(view: Layoutable) -> LayoutOperation {
    return SizeToFit(view, width: .Max, height: .Max)
}

/**
 same as SizeToFit(view, width: .Current, height: .Current)
 */
public func SizeToFit(view: Layoutable) -> LayoutOperation {
    return SizeToFit(view, width: .Current, height: .Current)
}

/**
 same as SizeToFit(view, width: .Max, height: .Max)
 */
public func SizeToFitMaxWithConstraints(view: Layoutable, widthConstraint: SizeConstraint, heightConstraint: SizeConstraint) -> LayoutOperation {
    return SizeToFit(view, width: .Max, height: .Max, widthConstraint: widthConstraint, heightConstraint: heightConstraint)
}

//MARK: - fit height fill width

/**
 Combine(
    HFill(view, leftInset: leftInset, rightInset: rightInset),
    SizeToFit(view, width: .KeepCurrent, height: .Max),
 )
*/
public func HFillVFit(view: Layoutable, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return Combine([
        HFill(view, leftInset: leftInset, rightInset: rightInset),
        SizeToFit(view, width: .KeepCurrent, height: .Max),
    ])
}

public func HFillVFit(view: Layoutable, inset: CGFloat) -> LayoutOperation {
    return HFillVFit(view, leftInset: inset, rightInset: inset)
}

public func HFillVFit(view: Layoutable) -> LayoutOperation {
    return HFillVFit(view, leftInset: 0, rightInset: 0)
}
