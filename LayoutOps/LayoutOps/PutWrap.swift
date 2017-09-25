//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation


public enum FixStrategy {
    case first //all elements in fix equal to first
    case min //all elements in fix equal to max element
    case max //all elements in fix equal to min element
    case value(CGFloat) //all elements in fix equal to value
}

public enum PutIntention {
    
    /**
     1. (view: v weight: x) - view with size calculated from weights
     2. (view: nil weight: x) - empty space with size calculated from weights
     
     weight is 1.0 by default
     */
    case flex(views: [Layoutable]?, weight: CGFloat)
    
    /**
     1. (view: v value: x) - view with fixed size
     2. (view: nil value: x) - empty space with fixed size
     3. (view: v value: nil) - keep current size of view, second and other will be the same with first
     4. (view: nil value: nil) - do nothing, nop
     
     */
    case fix(views: [Layoutable]?, strategy: FixStrategy)
    
    public func when(_ condition: () -> Bool) -> PutIntention {
        if condition() {
            return self
        } else {
            return Fix()
        }
    }
}

//MARK: - PutIntention shorthands


//MARK: - Flex shorthands
public func Flex(_ weight: CGFloat) -> PutIntention {
    return .flex(views: nil, weight: weight)
}

public func Flex(_ view: Layoutable) -> PutIntention {
    return Flex([view])
}

public func Flex(_ views: [Layoutable]) -> PutIntention {
    return Flex(views, 1.0)
}

public func Flex() -> PutIntention {
    return .flex(views: nil, weight: 1.0)
}

public func Flex(_ view: Layoutable, _ weight: CGFloat) -> PutIntention {
    return Flex([view], weight)
}

public func Flex(_ views: [Layoutable], _ weight: CGFloat) -> PutIntention {
    return .flex(views: views, weight: weight)
}

//MARK: - Fix shorthands
public func Fix(_ value: CGFloat) -> PutIntention {
    return .fix(views: nil, strategy: .value(value))
}

public func Fix(_ view: Layoutable) -> PutIntention {
    return .fix(views: [view], strategy: .first)
}

public func Fix(_ views: [Layoutable]) -> PutIntention {
    return .fix(views: views, strategy: .first)
}

public func Fix(_ views: [Layoutable], _ strategy: FixStrategy) -> PutIntention {
    return .fix(views: views, strategy: strategy)
}

public func Fix() -> PutIntention {
    return .fix(views: nil, strategy: .value(0))
}

public func Fix(_ view: Layoutable, _ value: CGFloat) -> PutIntention {
    return .fix(views: [view], strategy: .value(value))
}

public func Fix(_ views: [Layoutable], _ value: CGFloat) -> PutIntention {
    return .fix(views: views, strategy: .value(value))
}

//MARK: - WrapIntention
public enum WrapIntention {
    
    case fix(views: [Layoutable]?, strategy: FixStrategy)
    
    public func when(_ condition: () -> Bool) -> WrapIntention {
        if condition() {
            return self
        } else {
            return Fix() //in fact NOP
        }
    }
    
    fileprivate var putIntention: PutIntention {
        switch self {
        case .fix(let views, let strategy):
            return .fix(views: views, strategy: strategy)
        }
    }
}

//MARK: - Fix shorthands
public func Fix(_ value: CGFloat) -> WrapIntention {
    return .fix(views: nil, strategy: .value(value))
}

public func Fix(_ view: Layoutable) -> WrapIntention {
    return .fix(views: [view], strategy: .first)
}

public func Fix(_ views: [Layoutable]) -> WrapIntention {
    return .fix(views: views, strategy: .first)
}

public func Fix(_ views: [Layoutable], _ strategy: FixStrategy) -> WrapIntention {
    return .fix(views: views, strategy: strategy)
}

public func Fix() -> WrapIntention {
    return .fix(views: nil, strategy: .value(0))
}

public func Fix(_ view: Layoutable, _ value: CGFloat) -> WrapIntention {
    return .fix(views: [view], strategy: .value(value))
}

public func Fix(_ views: [Layoutable], _ value: CGFloat) -> WrapIntention {
    return .fix(views: views, strategy: .value(value))
}

//MARK: - private layout code
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

extension FixStrategy {
    fileprivate func calculateValue<T: BoxDimension>(forViews views: [Layoutable]?, dimension: T) -> CGFloat {
        switch self {
        case .first:
            if let views = views, views.count > 0 {
                return T.getDimension(views[0].frame).size
            } else {
                return 0
            }
        case .max:
            if let views = views, views.count > 0 {
                return views.reduce(CGFloat.leastNormalMagnitude) { Swift.max($0, T.getDimension($1.frame).size) }
            } else {
                return 0
            }
        case .min:
            if let views = views, views.count > 0 {
                return views.reduce(CGFloat.greatestFiniteMagnitude) { Swift.min($0, T.getDimension($1.frame).size) }
            } else {
                return 0
            }
        case .value(let v):
            return v
        }
    }
}

private func putOperation<T: BoxDimension>(_ superview: Layoutable, intentions: [PutIntention], dimension: T, wrapParent: Bool) {
    
    func testView(view: Layoutable) {
        if view.lx_parent == nil {
            print("[WARNING:LayoutOps:put] nil parent for \(view)")
        } else if view.lx_parent !== superview {
            print("[WARNING:LayoutOps:put] wrong parent \(view)")
        }
    }
    
    for i in intentions {
        switch (i) {
        case .flex(let views, _):
            views?.forEach(testView)
            break
        case .fix(let views, _):
            views?.forEach(testView)
            break
        }
    }
    
    var totalWeight: CGFloat = 0.0
    
    let bounds = superview.boundsOrViewPort
    
    var totalSizeForFlexs = T.getDimension(bounds).size
    
    for i in intentions {
        switch (i) {
        case .flex(_, let weight):
            totalWeight += weight
        case .fix(let views, let value):
            totalSizeForFlexs -= value.calculateValue(forViews: views, dimension: dimension)
        }
    }
    
    let unoSize = totalSizeForFlexs/totalWeight
    
    var start = T.getDimension(bounds).origin
    for i in intentions {
        switch (i) {
        case .flex(let views, let weight):
            
            let newSize = weight * unoSize
            
            if let views = views {
                views.forEach {view in
                    let fr = view.frame
                    view.updateFrame(T.setDimension(Dimension(origin: start, size: newSize), inRect: fr))
                }
                
                start += newSize
            } else {
                start += newSize
            }
            
            totalWeight += weight
        case .fix(let views, let strategy):
            let value = strategy.calculateValue(forViews: views, dimension: dimension)
            
            views?.forEach {
                let fr = $0.frame
                $0.updateFrame(T.setDimension(Dimension(origin: start, size: value), inRect: fr))
            }            
            start += value
        }
    }
    
    if wrapParent {
        let dim = T.getDimension(superview.frame)        
        superview.frame = T.setDimension(Dimension(origin: dim.origin, size: start - T.getDimension(bounds).origin), inRect: superview.frame)
    }
}

extension Layouting where Base: Layoutable {
    //MARK: - HPut
    
    @discardableResult
    public func hput(_ intentions: [PutIntention]) -> Layouting<Base> {
        putOperation(base, intentions: intentions, dimension: BoxWidth(), wrapParent: false)
        return self
    }
    
    @discardableResult
    public func hput(_ intentions: PutIntention...) -> Layouting<Base> {
        putOperation(base, intentions: intentions, dimension: BoxWidth(), wrapParent: false)
        return self
    }
    
    //MARK: - VPut
    
    @discardableResult
    public func vput(_ intentions: [PutIntention]) -> Layouting<Base> {
        putOperation(base, intentions: intentions, dimension: BoxHeight(), wrapParent: false)
        return self
    }
    
    @discardableResult
    public func vput(_ intentions: PutIntention...) -> Layouting<Base> {
        putOperation(base, intentions: intentions, dimension: BoxHeight(), wrapParent: false)
        return self
    }
}

extension Layouting where Base: Layoutable {
    //MARK: - HPut
    
    @discardableResult
    public func hwrap(_ intentions: WrapIntention...) -> Layouting<Base> {
        putOperation(base, intentions: intentions.map { $0.putIntention }, dimension: BoxWidth(), wrapParent: true)
        return self
    }
    
    @discardableResult
    public func hwrap(_ intentions: [WrapIntention]) -> Layouting<Base> {
        putOperation(base, intentions: intentions.map { $0.putIntention }, dimension: BoxWidth(), wrapParent: true)
        return self
    }
    //MARK: - VPut
    
    @discardableResult
    public func vwrap(_ intentions: WrapIntention...) -> Layouting<Base> {
        putOperation(base, intentions: intentions.map { $0.putIntention }, dimension: BoxHeight(), wrapParent: true)
        return self
    }
    
    @discardableResult
    public func vwrap(_ intentions: [WrapIntention]) -> Layouting<Base> {
        putOperation(base, intentions: intentions.map { $0.putIntention }, dimension: BoxHeight(), wrapParent: true)
        return self
    }
}
    

