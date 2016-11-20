//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public enum SizeToFitIntention {
    /**
     Use defined value
     */
    case value(CGFloat)
    /**
     Use max value to fully fit content
     */
    case max
    /**
     Use current frame value to fit content in it
     */
    case current
    /**
     Use current frame value for fit calculation, but keep it as value for frame
     */
    case keepCurrent
}

public enum SizeConstraint {
    case any
    case min(CGFloat)
    case max(CGFloat)
    case minMax(CGFloat, CGFloat)
    
    
    public var minValue: CGFloat {
        switch self {
        case .any, .max:
            return CGFloat.leastNormalMagnitude
        case .min(let min):
            return min
        case .minMax(let min, _):
            return min
        }
    }
    
    public var maxValue: CGFloat {
        switch self {
        case .any, .min:
            return CGFloat.greatestFiniteMagnitude
        case .max(let max):
            return max
        case .minMax(_, let max):
            return max
        }
    }
}

private struct SizeToFitOperation: LayoutOperation {
    let view: UIView
    let width: SizeToFitIntention
    let height: SizeToFitIntention
    let widthSizeConstraint: SizeConstraint
    let heightSizeConstraint: SizeConstraint
    
    func calculateLayouts(_ layouts: inout ViewLayoutMap, viewport: Viewport) {
        
        let fr = frameForView(view, layouts: &layouts)
        
        var w: CGFloat = 0
        switch width {
        case .value(let val):
            w = val
        case .max:
            w = CGFloat.greatestFiniteMagnitude
        case .current:
            w = fr.width
        case .keepCurrent:
            w = fr.width
        }
        
        var h: CGFloat = 0
        switch height {
        case .value(let val):
            h = val
        case .max:
            h = CGFloat.greatestFiniteMagnitude
        case .current:
            h = fr.height
        case .keepCurrent:
            h = fr.height
        }
        
        var sz = view.sizeThatFits(CGSize(width: w, height: h))
        
        
        switch width {
        case .value(let val):
            sz.width = min(val, sz.width)
        case .max:
            break
        case .current:
            break
        case .keepCurrent:
            sz.width = fr.width
        }
        
        switch height {
        case .value(let val):
            sz.height = min(val, sz.height)
        case .max:
            break
        case .current:
            break
        case .keepCurrent:
            sz.height = fr.height
        }
        
        sz.width = min(max(widthSizeConstraint.minValue, sz.width), widthSizeConstraint.maxValue)
        sz.height = min(max(heightSizeConstraint.minValue, sz.height), heightSizeConstraint.maxValue)
        
        SetSize(view, width: sz.width, height: sz.height).calculateLayouts(&layouts, viewport: viewport)
    }
}

public func SizeToFit(_ view: UIView, width: SizeToFitIntention, height: SizeToFitIntention, widthConstraint: SizeConstraint = .any, heightConstraint: SizeConstraint = .any) -> LayoutOperation {
    return SizeToFitOperation(view: view, width: width, height: height, widthSizeConstraint: widthConstraint, heightSizeConstraint:  heightConstraint)
}

/**
 same as SizeToFit(view, width: .Max, height: .Max)
 */
public func SizeToFitMax(_ view: UIView) -> LayoutOperation {
    return SizeToFit(view, width: .max, height: .max)
}

/**
 same as SizeToFit(view, width: .Current, height: .Current)
 */
public func SizeToFit(_ view: UIView) -> LayoutOperation {
    return SizeToFit(view, width: .current, height: .current)
}

/**
 same as SizeToFit(view, width: .Max, height: .Max)
 */
public func SizeToFitMaxWithConstraints(_ view: UIView, widthConstraint: SizeConstraint, heightConstraint: SizeConstraint) -> LayoutOperation {
    return SizeToFit(view, width: .max, height: .max, widthConstraint: widthConstraint, heightConstraint: heightConstraint)
}

//MARK: - fit height fill width

/**
 Combine(
    HFill(view, leftInset: leftInset, rightInset: rightInset),
    SizeToFit(view, width: .KeepCurrent, height: .Max),
 )
*/
public func HFillVFit(_ view: UIView, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return Combine([
        HFill(view, leftInset: leftInset, rightInset: rightInset),
        SizeToFit(view, width: .keepCurrent, height: .max),
    ])
}

public func HFillVFit(_ view: UIView, inset: CGFloat) -> LayoutOperation {
    return HFillVFit(view, leftInset: inset, rightInset: inset)
}

public func HFillVFit(_ view: UIView) -> LayoutOperation {
    return HFillVFit(view, leftInset: 0, rightInset: 0)
}
