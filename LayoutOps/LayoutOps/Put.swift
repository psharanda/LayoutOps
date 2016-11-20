//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public enum PutIntention {
    
    /**
     1. (view: v weight: x) - view with size calculated from weights
     2. (view: nil weight: x) - empty space with size calculated from weights
     
     weight is 1.0 by default
     */
    case flexIntention(views: [UIView]?, weight: CGFloat)
    
    /**
     1. (view: v value: x) - view with fixed size
     2. (view: nil value: x) - empty space with fixed size
     3. (view: v value: nil) - keep current size of view, second and other will be the same with first
     4. (view: nil value: nil) - do nothing, nop
     
     */
    case fixIntention(views: [UIView]?, value: CGFloat?)
    
    public func when(_ condition: (Void) -> Bool) -> PutIntention {
        if condition() {
            return self
        } else {
            return Fix() //in fact NOP
        }
    }
}

//MARK: - PutIntention shorthands


//MARK: - Flex shorthands
public func Flex(_ weight: CGFloat) -> PutIntention {
    return .flexIntention(views: nil, weight: weight)
}

public func Flex(_ view: UIView) -> PutIntention {
    return Flex([view])
}

public func Flex(_ views: [UIView]) -> PutIntention {
    return Flex(views, 1.0)
}

public func Flex() -> PutIntention {
    return .flexIntention(views: nil, weight: 1.0)
}

public func Flex(_ view: UIView, _ weight: CGFloat) -> PutIntention {
    return Flex([view], weight)
}

public func Flex(_ views: [UIView], _ weight: CGFloat) -> PutIntention {
    return .flexIntention(views: views, weight: weight)
}

//MARK: - Fix shorthands
public func Fix(_ value: CGFloat) -> PutIntention {
    return .fixIntention(views: nil, value: value)
}

public func Fix(_ view: UIView) -> PutIntention {
    return .fixIntention(views: [view], value: nil)
}

public func Fix(_ views: [UIView]) -> PutIntention {
    return .fixIntention(views: views, value: nil)
}

public func Fix() -> PutIntention {
    return .fixIntention(views: nil, value: nil)
}

public func Fix(_ view: UIView, _ value: CGFloat) -> PutIntention {
    return Fix([view], value)
}

public func Fix(_ views: [UIView], _ value: CGFloat) -> PutIntention {
    return .fixIntention(views: views, value: value)
}

private struct Dimension {
    let origin: CGFloat
    let size: CGFloat
}

private protocol BoxDimension {
    static func getDimension(_ rect: CGRect) -> Dimension
    static func setDimension(_ dimension: Dimension, inRect: CGRect) -> CGRect
}

private struct BoxWidth: BoxDimension {
    
    static func getDimension(_ rect: CGRect) -> Dimension {
        return Dimension(origin: rect.origin.x, size: rect.size.width)
    }
    static func setDimension(_ dimension: Dimension, inRect: CGRect) -> CGRect {
        var result = inRect
        result.origin.x = dimension.origin
        result.size.width = dimension.size
        return result
    }
}

private struct BoxHeight: BoxDimension {
    
    static func getDimension(_ rect: CGRect) -> Dimension {
        return Dimension(origin: rect.origin.y, size: rect.size.height)
    }
    static func setDimension(_ dimension: Dimension, inRect: CGRect) -> CGRect {
        var result = inRect
        result.origin.y = dimension.origin
        result.size.height = dimension.size
        return result
    }
}

private struct PutLayoutOperation<T:BoxDimension> : LayoutOperation {
    let intentions: [PutIntention]
    
    init(intentions: [PutIntention]) {
        self.intentions = intentions
    }
    
    func calculateLayouts(_ layouts: inout ViewLayoutMap, viewport: Viewport) {
        
        var superview: UIView? = nil
        
        //search for superview first
        for i in intentions {
            
            var view: UIView? = nil
            switch (i) {
            case .flexIntention(let views, _):
                view = views?.first
            case .fixIntention(let views, _):
                view = views?.first
            }
            
            if let v = view?.superview {
                
                if !(superview == nil || v == superview) {
                    print("[LayoutOps:WARNING] Put operation will produce undefined results for views with different superview")
                    print("Correct Superview: \(superview)")
                    print("Wrong Superview: \(v)")
                }
                superview = v;
            }
        }
        
        if let superview = superview {
            
            var totalWeight: CGFloat = 0.0
            
            var bounds = superview.bounds
            if let superViewFrame = layouts[superview] {
                bounds = CGRect(x: 0, y: 0, width: superViewFrame.width, height: superViewFrame.height)
            }
            
            viewport.verify(superview)
            
            bounds = viewport.apply(bounds, layouts: layouts)
            
            var totalSizeForFlexs: CGFloat = T.getDimension(bounds).size
            
            for i in intentions {
                switch (i) {
                case .flexIntention(_, let weight):
                    totalWeight += weight
                    break
                case .fixIntention(let views, let value):
                    if let value = value {
                        totalSizeForFlexs -= value
                    } else {
                        if let firstView = views?.first {
                            totalSizeForFlexs -= T.getDimension(frameForView(firstView, layouts: &layouts)).size
                        }
                    }
                    break
                }
            }
            
            let unoSize = totalSizeForFlexs/totalWeight
            
            var start:CGFloat = T.getDimension(bounds).origin
            for i in intentions {
                switch (i) {
                case .flexIntention(let views, let weight):
                    
                    let newSize = weight * unoSize
                    
                    if let views = views {
                        views.forEach {view in
                            let fr = frameForView(view, layouts: &layouts)
                            layouts[view] = T.setDimension(Dimension(origin: start, size: newSize), inRect: fr)
                        }
                        
                        start += newSize
                    } else {
                        start += newSize
                    }
                    
                    totalWeight += weight
                    break
                case .fixIntention(let views, let value):
                    if let value = value {
                        if let views = views {
                            views.forEach {view in
                                let fr = frameForView(view, layouts: &layouts)
                                layouts[view] = T.setDimension(Dimension(origin: start, size: value), inRect: fr)
                            }
                            start += value
                        } else {
                            start += value
                        }
                    } else {
                        if let views = views, let firstView = views.first {
                            
                            let size = T.getDimension(frameForView(firstView, layouts: &layouts)).size
                            
                            views.forEach {view in
                                let fr = frameForView(view, layouts: &layouts)
                                layouts[view] = T.setDimension(Dimension(origin: start, size: size), inRect: fr)
                            }
                            start += size
                        }
                    }
                    break
                }
            }
        }
    }
}

//MARK: - HPut

public func HPut(_ intentions: [PutIntention]) -> LayoutOperation {
    return PutLayoutOperation<BoxWidth>(intentions: intentions)
}

public func HPut(_ intentions: PutIntention...) -> LayoutOperation {
    return PutLayoutOperation<BoxWidth>(intentions: intentions)
}

//MARK: - VPut

public func VPut(_ intentions: [PutIntention]) -> LayoutOperation {
    return PutLayoutOperation<BoxHeight>(intentions: intentions)
}

public func VPut(_ intentions: PutIntention...) -> LayoutOperation {
    return PutLayoutOperation<BoxHeight>(intentions: intentions)
}

