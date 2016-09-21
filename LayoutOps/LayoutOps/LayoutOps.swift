//
//  LayoutOps.swift
//  LayoutOps
//
//  Created by Pavel Sharanda on 19.04.16.
//
//

import UIKit

private extension CGFloat {
     var pixelPerfect: CGFloat {
        let scale = UIScreen.main.scale;
        return (self * scale).rounded()/scale;
    }
}

//MARK: - viewport

public enum HViewAnchor {
    case parent
    case left(UIView?)
    case hCenter(UIView?)
    case right(UIView?)
    
    func anchorValue(forLayouts layouts: [UIView: CGRect]) -> CGFloat? {
        switch self {
        case .parent:
            return nil
        case .left(let v):
            return v.flatMap { layouts[$0]?.origin.x } ?? 0
        case .right(let v):
            return v.flatMap { layouts[$0].flatMap { $0.origin.x + $0.size.width }  } ?? 0
        case .hCenter(let v):
            return v.flatMap { layouts[$0].flatMap { $0.origin.x + $0.size.width/2 }  } ?? 0
        }
    }
}

public enum VViewAnchor {
    case parent
    case top(UIView?)
    case bottom(UIView?)
    case vCenter(UIView?)
    
    func anchorValue(forLayouts layouts: [UIView: CGRect]) -> CGFloat? {
        switch self {
        case .parent:
            return nil
        case .top(let v):
            return v.flatMap { layouts[$0]?.origin.y } ?? 0
        case .bottom(let v):
            return v.flatMap { layouts[$0].flatMap { $0.origin.y + $0.size.height }  } ?? 0
        case .vCenter(let v):
            return v.flatMap { layouts[$0].flatMap { $0.origin.y + $0.size.height/2 }  } ?? 0
        }
    }
}

public struct Viewport {
    let topAnchor: VViewAnchor
    let bottomAnchor: VViewAnchor
    let leftAnchor: HViewAnchor
    let rightAnchor: HViewAnchor
    
    public init(topAnchor: VViewAnchor, leftAnchor: HViewAnchor, bottomAnchor: VViewAnchor, rightAnchor: HViewAnchor) {
        self.topAnchor = topAnchor
        self.leftAnchor = leftAnchor
        self.bottomAnchor = bottomAnchor
        self.rightAnchor = rightAnchor
    }
    
    public init() {
        self.topAnchor = .parent
        self.leftAnchor = .parent
        self.bottomAnchor = .parent
        self.rightAnchor = .parent
    }
    
    func apply(bounds: CGRect, layouts:[UIView: CGRect]) -> CGRect {
        let left = leftAnchor.anchorValue(forLayouts: layouts) ?? bounds.origin.x
        let top = topAnchor.anchorValue(forLayouts: layouts) ?? bounds.origin.y
        let right = rightAnchor.anchorValue(forLayouts: layouts) ?? bounds.maxX
        let bottom = bottomAnchor.anchorValue(forLayouts: layouts) ?? bounds.maxY
        
        return CGRect(x: left, y: top, width: right - left, height: bottom - top)
    }
}

//MARK: - LayoutOperation

public protocol LayoutOperation {
    func calculate(layouts:inout [UIView: CGRect], viewport: Viewport)
}

public extension LayoutOperation {
    func layout() {
        
        var layoutsMap = [UIView: CGRect]()
        calculate(layouts: &layoutsMap, viewport: Viewport())
        for (view, frame) in layoutsMap {
            view.frame = CGRect(x: frame.origin.x.pixelPerfect, y: frame.origin.y.pixelPerfect, width: frame.size.width.pixelPerfect, height: frame.size.height.pixelPerfect)
        }
    }
    
    func preciseLayout() {
        var layoutsMap = [UIView: CGRect]()
        calculate(layouts: &layoutsMap, viewport: Viewport())
        for (view, frame) in layoutsMap {
            view.frame = frame
        }
    }
    
    func when(_ condition: (Void) -> Bool) -> LayoutOperation {
        if condition() {
            return self
        } else {
            return NoLayoutOperation()
        }
    }
}

private extension LayoutOperation {
    func frame(forView view: UIView, layouts: inout [UIView : CGRect]) -> CGRect {
        if let r = layouts[view] {
            return r
        } else {
            layouts[view] = view.frame
            return view.frame
        }
    }
}

//MARK: - NOOP

private struct NoLayoutOperation: LayoutOperation {
    
    func calculate(layouts: inout [UIView : CGRect], viewport: Viewport) {
        
    }
}

public func NOOP() -> LayoutOperation {
    return NoLayoutOperation()
}

//MARK: - Combine

private struct CombineOperation : LayoutOperation {
    
    let layoutOperations: [LayoutOperation]
    
    let viewport: Viewport?
    
    func calculate(layouts: inout [UIView : CGRect], viewport: Viewport) {
        for layoutOperation in layoutOperations {
            layoutOperation.calculate(layouts: &layouts, viewport: self.viewport ?? viewport)
        }
    }
    
    init(layoutOperations: [LayoutOperation], viewport: Viewport? = nil) {
        self.layoutOperations = layoutOperations
        self.viewport = viewport
    }
}

public func Combine(_ operations: [LayoutOperation]) -> LayoutOperation {
    return CombineOperation(layoutOperations: operations)
}

public func Combine(viewport: Viewport, operations: [LayoutOperation]) -> LayoutOperation {
    return CombineOperation(layoutOperations: operations, viewport: viewport)
}

public func Combine(_ operations: LayoutOperation...) -> LayoutOperation {
    return CombineOperation(layoutOperations: operations)
}

public func Combine(viewport: Viewport, operations: LayoutOperation...) -> LayoutOperation {
    return CombineOperation(layoutOperations: operations, viewport: viewport)
}


//MARK: - x & y & width & height
private protocol DirectLayoutAction {
    static func update(rect: CGRect, withValue: CGFloat) -> CGRect
}

private struct LeftDirectLayoutAction : DirectLayoutAction {
    static func update(rect:  CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.origin.x = withValue
        return result
    }
}

private struct TopDirectLayoutAction : DirectLayoutAction {
    static func update(rect:  CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.origin.y = withValue
        return result
    }
}

private struct BottomDirectLayoutAction : DirectLayoutAction {
    static func update(rect:  CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.origin.y = withValue - rect.size.height
        
        return result
    }
}

private struct RightDirectLayoutAction : DirectLayoutAction {
    static func update(rect:  CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.origin.x = withValue - rect.size.width
        return result
    }
}

private struct WidthDirectLayoutAction : DirectLayoutAction {
    static func update(rect:  CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.size.width = withValue
        return result
    }
}

private struct HeightDirectLayoutAction : DirectLayoutAction {
    static func update(rect:  CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.size.height = withValue
        return result
    }
}

private struct DirectLayoutOperation<T:DirectLayoutAction> : LayoutOperation
{
    let view: UIView?
    let value: CGFloat
    func calculate(layouts: inout [UIView : CGRect], viewport: Viewport) {
        
        guard let view = view else {
            return
        }
        
        layouts[view] = T.update(rect: frame(forView: view, layouts: &layouts), withValue: value)
    }
}

public func SetX(_ view: UIView?, value: CGFloat) -> LayoutOperation {
    return SetLeft(view, value: value)
}

public func SetY(_ view: UIView?, value: CGFloat) -> LayoutOperation {
    return SetTop(view, value: value)
}

public func SetWidth(_ view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<WidthDirectLayoutAction>(view: view, value: value)
}

public func SetHeight(_ view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<HeightDirectLayoutAction>(view: view, value: value)
}

public func SetLeft(_ view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<LeftDirectLayoutAction>(view: view, value: value)
}

public func SetRight(_ view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<RightDirectLayoutAction>(view: view, value: value)
}

public func SetTop(_ view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<TopDirectLayoutAction>(view: view, value: value)
}

public func SetBottom(_ view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<BottomDirectLayoutAction>(view: view, value: value)
}

//MARK: - size

public func SetSize(_ view: UIView?, width: CGFloat, height: CGFloat) -> LayoutOperation {
    return Combine( [
        SetWidth(view, value: width),
        SetHeight(view, value: height)
    ])
}

public func SetSize(_ view: UIView?, size: CGSize) -> LayoutOperation {
    return Combine( [
        SetWidth(view, value: size.width),
        SetHeight(view, value: size.height)
        ])
}

public func SetFrame(_ view: UIView?, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> LayoutOperation {
    return Combine( [
        SetLeft(view, value: x),
        SetTop(view, value: y),
        SetWidth(view, value: width),
        SetHeight(view, value: height)
    ])
}

public func SetFrame(_ view: UIView?, frame: CGRect) -> LayoutOperation {
    return Combine( [
        SetLeft(view, value: frame.origin.x),
        SetTop(view, value: frame.origin.y),
        SetWidth(view, value: frame.size.width),
        SetHeight(view, value: frame.size.height)
    ])
}

//MARK: - size to fit

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


private struct SizeToFitOperation: LayoutOperation {
    let view: UIView?
    let width: SizeToFitIntention
    let height: SizeToFitIntention
    let widthSizeConstraint: SizeConstraint
    let heightSizeConstraint: SizeConstraint
    
    func calculate(layouts: inout [UIView : CGRect], viewport: Viewport) {
        
        guard let view = view else {
            return
        }
        
        let fr = frame(forView: view, layouts: &layouts)
        
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
        
        if case .keepCurrent = width {
            sz.width = fr.width
        }
        
        if case .keepCurrent = height {
            sz.height = fr.height
        }
        
        sz.width = min(max(widthSizeConstraint.minValue, sz.width), widthSizeConstraint.maxValue)
        sz.height = min(max(heightSizeConstraint.minValue, sz.height), heightSizeConstraint.maxValue)
        
        SetSize(view, width: sz.width, height: sz.height).calculate(layouts: &layouts, viewport: viewport)
    }
}

public func SizeToFit(_ view: UIView?, width: SizeToFitIntention, height: SizeToFitIntention, widthConstraint: SizeConstraint = .default, heightConstraint: SizeConstraint = .default) -> LayoutOperation {
    return SizeToFitOperation(view: view, width: width, height: height, widthSizeConstraint: widthConstraint, heightSizeConstraint:  heightConstraint)
}

/**
 same as SizeToFit(view, width: .Max, height: .Max)
*/
public func SizeToFitMax(_ view: UIView?) -> LayoutOperation {
    return SizeToFit(view, width: .max, height: .max)
}

/**
 same as SizeToFit(view, width: .Current, height: .Current)
*/
public func SizeToFit(_ view: UIView?) -> LayoutOperation {
    return SizeToFit(view, width: .current, height: .current)
}

/**
 same as SizeToFit(view, width: .Max, height: .Max)
 */
public func SizeToFitConstraints(_ view: UIView?, height: SizeToFitIntention, widthConstraint: SizeConstraint, heightConstraint: SizeConstraint) -> LayoutOperation {
    return SizeToFit(view, width: .max, height: .max, widthConstraint: widthConstraint, heightConstraint: heightConstraint)
}

//MARK: - Put

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

public func Flex(_ view: UIView?) -> PutIntention {
    return Flex([view])
}

public func Flex(_ views: [UIView?]) -> PutIntention {
    return Flex(views, 1.0)
}

public func Flex() -> PutIntention {
    return .flexIntention(views: nil, weight: 1.0)
}

public func Flex(_ view: UIView?, _ weight: CGFloat) -> PutIntention {
    return Flex([view], weight)
}

public func Flex(_ views: [UIView?], _ weight: CGFloat) -> PutIntention {
    let nonNilViews = views.flatMap { $0 }
    return .flexIntention(views: nonNilViews, weight: weight)
}

//MARK: - Fix shorthands
public func Fix(_ value: CGFloat) -> PutIntention {
    return .fixIntention(views: nil, value: value)
}

public func Fix(_ view: UIView?) -> PutIntention {
    return .fixIntention(views: view.flatMap{[$0]} ?? nil, value: nil)
}

public func Fix(_ views: [UIView?]) -> PutIntention {
    let nonNilViews = views.flatMap { $0 }
    return .fixIntention(views: nonNilViews, value: nil)
}

public func Fix() -> PutIntention {
    return .fixIntention(views: nil, value: nil)
}

public func Fix(_ view: UIView?, _ value: CGFloat) -> PutIntention {
    return Fix([view], value)
}

public func Fix(_ views: [UIView?], _ value: CGFloat) -> PutIntention {
    let nonNilViews = views.flatMap { $0 }
    return .fixIntention(views: nonNilViews, value: value)
}

private struct Dimension {
    let origin: CGFloat
    let size: CGFloat
}

private protocol BoxDimension {
    static func get(dimensionInRect rect: CGRect) -> Dimension
    static func set(dimension: Dimension, inRect: CGRect) -> CGRect
}

private struct BoxWidth: BoxDimension {
    
    static func get(dimensionInRect rect: CGRect) -> Dimension {
        return Dimension(origin: rect.origin.x, size: rect.size.width)
    }
    static func set(dimension: Dimension, inRect: CGRect) -> CGRect {
        var result = inRect
        result.origin.x = dimension.origin
        result.size.width = dimension.size
        return result
    }
}

private struct BoxHeight: BoxDimension {
    
    static func get(dimensionInRect rect: CGRect) -> Dimension {
        return Dimension(origin: rect.origin.y, size: rect.size.height)
    }
    static func set(dimension: Dimension, inRect: CGRect) -> CGRect {
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
    
    func calculate(layouts: inout [UIView : CGRect], viewport: Viewport) {
        
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
                assert(superview == nil || v == superview, "Layout intentions can't be calculated for views with diffferent superview")
                superview = v;
            }
        }
        
        if let superview = superview {
            
            var totalWeight: CGFloat = 0.0
            
            var bounds = superview.bounds
            if let superViewFrame = layouts[superview] {
                bounds = CGRect(x: 0, y: 0, width: superViewFrame.width, height: superViewFrame.height)
            }
            
            bounds = viewport.apply(bounds: bounds, layouts: layouts)
            
            var totalSizeForFlexs: CGFloat = T.get(dimensionInRect: bounds).size
            
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
                            totalSizeForFlexs -= T.get(dimensionInRect: frame(forView: firstView, layouts: &layouts)).size
                        }
                    }
                    break
                }
            }
            
            let unoSize = totalSizeForFlexs/totalWeight
            
            var start:CGFloat = T.get(dimensionInRect: bounds).origin
            for i in intentions {
                switch (i) {
                case .flexIntention(let views, let weight):
                    
                    let newSize = weight * unoSize
                    
                    if let views = views {
                        views.forEach {view in
                            let fr = frame(forView: view, layouts: &layouts)
                            layouts[view] = T.set(dimension: Dimension(origin: start, size: newSize), inRect: fr)
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
                                let fr = frame(forView: view, layouts: &layouts)
                                layouts[view] = T.set(dimension: Dimension(origin: start, size: value), inRect: fr)
                            }
                            start += value
                        } else {
                            start += value
                        }
                    } else {
                        if let views = views, let firstView = views.first {
                            
                            let fr = frame(forView: firstView, layouts: &layouts)
                            let size = T.get(dimensionInRect: frame(forView: firstView, layouts: &layouts)).size
                            
                            views.forEach {view in
                                layouts[view] = T.set(dimension: Dimension(origin: start, size: size), inRect: fr)
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

public func HPut(_ intentions: [PutIntention]) -> LayoutOperation {
    return PutLayoutOperation<BoxWidth>(intentions: intentions)
}

public func VPut(_ intentions: [PutIntention]) -> LayoutOperation {
    return PutLayoutOperation<BoxHeight>(intentions: intentions)
}

public func HPut(_ intentions: PutIntention...) -> LayoutOperation {
    return PutLayoutOperation<BoxWidth>(intentions: intentions)
}

public func VPut(_ intentions: PutIntention...) -> LayoutOperation {
    return PutLayoutOperation<BoxHeight>(intentions: intentions)
}


//MARK: - center

public func Center(_ view: UIView?, insets: UIEdgeInsets) -> LayoutOperation {
    return Combine( [
        HCenter(view, leftInset: insets.left, rightInset: insets.right),
        VCenter(view, topInset: insets.top, bottomInset: insets.bottom)
        ])
}

public func Center(_ view: UIView?, inset: CGFloat) -> LayoutOperation {
    return Center(view, insets: UIEdgeInsetsMake(inset, inset, inset, inset))
}

public func Center(_ view: UIView?) -> LayoutOperation {
    return Center(view, insets: UIEdgeInsets.zero)
}

//MARK: - hcenter

public func HCenter(_ view: UIView?, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return HPut([Fix(leftInset), Flex(), Fix(view), Flex(), Fix(rightInset)])
}

public func HCenter(_ view: UIView?) -> LayoutOperation {
    return HCenter(view, leftInset: 0, rightInset: 0)
}

//MARK: - vcenter

public func VCenter(_ view: UIView?, topInset: CGFloat, bottomInset: CGFloat) -> LayoutOperation {
    return VPut([Fix(topInset), Flex(), Fix(view), Flex(), Fix(bottomInset)])
}

public func VCenter(_ view: UIView?) -> LayoutOperation {
    return VCenter(view, topInset: 0, bottomInset: 0)}

//MARK: - fill

public func Fill(_ view: UIView?, insets: UIEdgeInsets) -> LayoutOperation {
    return Combine( [
        HFill(view, leftInset: insets.left, rightInset: insets.right),
        VFill(view, topInset: insets.top, bottomInset: insets.bottom)
        ])
}

public func Fill(_ view: UIView?, inset: CGFloat) -> LayoutOperation {
    return Fill(view, insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
}

public func Fill(_ view: UIView?) -> LayoutOperation {
    return Fill(view, insets: UIEdgeInsets.zero)
}

//MARK: - hfill

public func HFill(_ view: UIView?, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return HPut([Fix(leftInset), Flex(view), Fix(rightInset)])
}

public func HFill(_ view: UIView?, inset: CGFloat) -> LayoutOperation {
    return HFill(view, leftInset: inset, rightInset: inset)
}

public func HFill(_ view: UIView?) -> LayoutOperation {
    return HFill(view, leftInset: 0, rightInset: 0)
}

//MARK: - vfill

public func VFill(_ view: UIView?, topInset: CGFloat, bottomInset: CGFloat) -> LayoutOperation {
    return VPut([Fix(topInset), Flex(view), Fix(bottomInset)])
}

public func VFill(_ view: UIView?, inset: CGFloat) -> LayoutOperation {
    return VFill(view, topInset: inset, bottomInset: inset)
}

public func VFill(_ view: UIView?) -> LayoutOperation {
    return VFill(view, topInset: 0, bottomInset: 0)
}

//MARK: - align top

public func AlignTop(_ view: UIView?, inset: CGFloat) -> LayoutOperation {
    return VPut([Fix(inset), Fix(view), Flex()])
}

public func AlignTop(_ view: UIView?) -> LayoutOperation {
    return AlignTop(view, inset: 0)
}

//MARK: - align left

public func AlignLeft(_ view: UIView?, inset: CGFloat) -> LayoutOperation {
    return HPut([Fix(inset), Fix(view), Flex()])
}

public func AlignLeft(_ view: UIView?) -> LayoutOperation {
    return AlignLeft(view, inset: 0)
}

//MARK: - align bottom

public func AlignBottom(_ view: UIView?, inset: CGFloat) -> LayoutOperation {
    return VPut([Flex(), Fix(view), Fix(inset)])
}

public func AlignBottom(_ view: UIView?) -> LayoutOperation {
    return AlignBottom(view, inset: 0)
}

//MARK: - align right

public func AlignRight(_ view: UIView?, inset: CGFloat) -> LayoutOperation {
    return HPut([Flex(), Fix(view), Fix(inset)])
}

public func AlignRight(_ view: UIView?) -> LayoutOperation {
    return AlignRight(view, inset: 0)
}

//MARK: - fit height fill width

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

//MARK: -  anchors

public protocol Anchor {
    func value(forRect: CGRect) -> CGFloat
    func set(value: CGFloat, forRect: CGRect) -> CGRect
    
    var view: UIView? {get}
}

//MARK: - hanchor

public enum HAnchor : Anchor {
    
    case left(UIView?, CGFloat)
    case center(UIView?, CGFloat)
    case right(UIView?, CGFloat)
    
    public func value(forRect rect: CGRect) -> CGFloat {
        switch self {
        case .left(_, let inset):
            return rect.minX + inset
        case .right(_, let inset):
            return rect.maxX + inset
        case .center(_, let inset):
            return rect.midX + inset
        }
    }
    
    public func set(value: CGFloat, forRect rect: CGRect) -> CGRect {
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
    
    public var view: UIView? {
        switch self {
        case .left(let v, _):
            return v
        case .right(let v, _):
            return v
        case .center(let v, _):
            return v
        }
    }
}

public func LeftAnchor(_ view: UIView?, inset: CGFloat) -> HAnchor {
    return HAnchor.left(view, inset)
}

public func LeftAnchor(_ view: UIView?) -> HAnchor {
    return LeftAnchor(view, inset: 0)
}

public func RightAnchor(_ view: UIView?, inset: CGFloat) -> HAnchor {
    return HAnchor.right(view, inset)
}

public func RightAnchor(_ view: UIView?) -> HAnchor {
    return RightAnchor(view, inset: 0)
}


public func HCenterAnchor(_ view: UIView?, inset: CGFloat) -> HAnchor {
    return HAnchor.center(view, inset)
}

public func HCenterAnchor(_ view: UIView?) -> HAnchor {
    return HCenterAnchor(view, inset: 0)
}


//MARK: - vanchor

public enum VAnchor : Anchor {
    case top(UIView?, CGFloat)
    case bottom(UIView?, CGFloat)
    case center(UIView?, CGFloat)
    
    public func value(forRect rect: CGRect) -> CGFloat {
        switch self {
        case .top(_, let inset):
            return rect.minY + inset
        case .bottom(_, let inset):
            return rect.maxY + inset
        case .center(_, let inset):
            return rect.midY + inset
        }
    }
    
    public func set(value: CGFloat, forRect rect: CGRect) -> CGRect {
        
        var result = rect
        
        switch self {
        case .top(_, let inset):
            result.origin.y = value - inset
        case .bottom(_, let inset):
            result.origin.y = value - result.size.height - inset
        case .center(_, let inset):
            result.origin.y = value - result.size.height/2 - inset
        }
        
        return result
    }
    
    public var view: UIView? {
        switch self {
        case .top(let v, _):
            return v
        case .bottom(let v, _):
            return v
        case .center(let v, _):
            return v
        }
    }
}

public func TopAnchor(_ view: UIView?, inset: CGFloat) -> VAnchor {
    return VAnchor.top(view, inset)
}

public func TopAnchor(_ view: UIView?) -> VAnchor {
    return TopAnchor(view, inset: 0)
}

public func BottomAnchor(_ view: UIView?, inset: CGFloat) -> VAnchor {
    return VAnchor.bottom(view, inset)
}

public func BottomAnchor(_ view: UIView?) -> VAnchor {
    return BottomAnchor(view, inset: 0)
}


public func VCenterAnchor(_ view: UIView?, inset: CGFloat) -> VAnchor {
    return VAnchor.center(view, inset)
}

public func VCenterAnchor(_ view: UIView?) -> VAnchor {
    return VCenterAnchor(view, inset: 0)
}

//MARK: - follow

private struct FollowOperation<T: Anchor> : LayoutOperation {
    
    let anchorToFollow: T
    let followerAnchor: T
    
    func calculate(layouts: inout [UIView : CGRect], viewport: Viewport) {
        
        guard let toFollowView = anchorToFollow.view, let followerView = followerAnchor.view else {
            return
        }
        
        assert(toFollowView.superview == followerView.superview)
        
        let anchorToFollowFrame = frame(forView: toFollowView, layouts: &layouts)
        let followerAnchorFrame = frame(forView: followerView, layouts: &layouts)
        
        layouts[followerView] = followerAnchor.set(value: anchorToFollow.value(forRect: anchorToFollowFrame), forRect: followerAnchorFrame)
    }
    
    init(anchorToFollow: T, followerAnchor: T) {
        self.anchorToFollow = anchorToFollow
        self.followerAnchor = followerAnchor
    }
    
}

// anchor.value + inset = withAnchor.value + inset

public func Follow<T: Anchor>(_ anchor: T, withAnchor: T) -> LayoutOperation {
    return FollowOperation(anchorToFollow: anchor, followerAnchor: withAnchor)
}

public func FollowCenter(_ ofView: UIView, dx dx1: CGFloat, dy dy1: CGFloat, withView: UIView, dx dx2: CGFloat, dy dy2: CGFloat) -> LayoutOperation {
    return Combine([
            Follow(HCenterAnchor(ofView, inset: dx1), withAnchor: HCenterAnchor(withView, inset: dx2)),
            Follow(VCenterAnchor(ofView, inset: dy1), withAnchor: VCenterAnchor(withView, inset: dy2))
        ])
}

public func FollowCenter(_ ofView: UIView, withView: UIView) -> LayoutOperation {
    return FollowCenter(ofView, dx: 0, dy: 0, withView: withView, dx: 0, dy: 0)
}

