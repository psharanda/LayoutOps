//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

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
    case `default`
    case min(CGFloat)
    case max(CGFloat)
    case minMax(CGFloat, CGFloat)
    
    
    public var minValue: CGFloat {
        switch self {
        case .default, .max:
            return CGFloat.leastNormalMagnitude
        case .min(let min):
            return min
        case .minMax(let min, _):
            return min
        }
    }
    
    public var maxValue: CGFloat {
        switch self {
        case .default, .min:
            return CGFloat.greatestFiniteMagnitude
        case .max(let max):
            return max
        case .minMax(_, let max):
            return max
        }
    }
}

extension Layouting where Base: Layoutable {
    
    @discardableResult
    public func sizeToFit(width: SizeToFitIntention = .current, height: SizeToFitIntention = .current, widthConstraint: SizeConstraint = .default, heightConstraint: SizeConstraint = .default) -> Layouting<Base> {
        
        
        let fr = base.lx_frame
        
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
        
        var sz = base.lx_sizeThatFits(CGSize(width: w, height: h))
        
        
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
        
        sz.width = min(max(widthConstraint.minValue, sz.width), widthConstraint.maxValue)
        sz.height = min(max(heightConstraint.minValue, sz.height), heightConstraint.maxValue)
        
        return set(width: sz.width, height: sz.height)
        
    }
    
    /**
     same as SizeToFit(view, width: .Max, height: .Max)
     */
    @discardableResult
    public func sizeToFitMax(widthConstraint: SizeConstraint = .default, heightConstraint: SizeConstraint = .default) -> Layouting<Base> {
        return sizeToFit(width: .max, height: .max, widthConstraint: widthConstraint, heightConstraint: heightConstraint)
    }
    
    @discardableResult
    public func hfillvfit(leftInset: CGFloat = 0, rightInset: CGFloat = 0) -> Layouting<Base> {
        return hfill(leftInset: leftInset, rightInset: rightInset).sizeToFit(width: .keepCurrent, height: .max)
    }
    
    @discardableResult
    public func hfillvfit(inset: CGFloat) -> Layouting<Base> {
        return hfillvfit(leftInset: inset, rightInset: inset)
    }
}
