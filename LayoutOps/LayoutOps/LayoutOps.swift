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
        let scale = UIScreen.mainScreen().scale;
        return round(self * scale)/scale;
    }
}

public protocol LayoutOperation {
    func calculateLayouts(inout layouts:[UIView: CGRect])
}

public extension LayoutOperation {
    func layout() {
        
        var layoutsMap = [UIView: CGRect]()
        calculateLayouts(&layoutsMap)
        for (view, frame) in layoutsMap {
            view.frame = CGRect(x: frame.origin.x.pixelPerfect, y: frame.origin.y.pixelPerfect, width: frame.size.width.pixelPerfect, height: frame.size.height.pixelPerfect)
        }
    }
    
    func preciseLayout() {
        var layoutsMap = [UIView: CGRect]()
        calculateLayouts(&layoutsMap)
        for (view, frame) in layoutsMap {
            view.frame = frame
        }
    }
    
    func when(condition: (Void) -> Bool) -> LayoutOperation {
        if condition() {
            return self
        } else {
            return NoLayoutOperation()
        }
    }
}

private extension LayoutOperation {
    func frameForView(view: UIView, inout layouts: [UIView : CGRect]) -> CGRect {
        if let r = layouts[view] {
            return r
        } else {
            layouts[view] = view.frame
            return view.frame
        }
    }
}

private struct NoLayoutOperation: LayoutOperation {
    func calculateLayouts(inout layouts: [UIView : CGRect]) {
        
    }
}

public func NOOP() -> LayoutOperation {
    return NoLayoutOperation()
}

private struct CombineOperation : LayoutOperation {
    
    let layoutOperations: [LayoutOperation]
    
    func calculateLayouts(inout layouts: [UIView : CGRect]) {
        for layoutOperation in layoutOperations {
            layoutOperation.calculateLayouts(&layouts)
        }
    }
    
    init(layoutOperations: [LayoutOperation]) {
        self.layoutOperations = layoutOperations
    }
}

public func Combine(layoutOperations: [LayoutOperation]) -> LayoutOperation {
    return CombineOperation(layoutOperations: layoutOperations)
}


public enum PutIntention {
    
    /**
     1. (view: v weight: x) - view with size calculated from weights
     2. (view: nil weight: x) - empty space with size calculated from weights
     
     weight is 1.0 by default
     */
    case FlexIntention(view: UIView?, weight: CGFloat)
    
    /**
     1. (view: v value: x) - view with fixed size
     2. (view: nil value: x) - empty space with fixed size
     3. (view: v value: nil) - keep current size of view
     4. (view: nil value: nil) - do nothing, nop
     
     */
    case FixIntention(view: UIView?, value: CGFloat?)
    
    public func when(condition: (Void) -> Bool) -> PutIntention {
        if condition() {
            return self
        } else {
            return Fix() //in fact NOP
        }
    }
}

//MARK: PutIntention shorthands
public func Flex(view: UIView?, _ weight: CGFloat) -> PutIntention {
    return .FlexIntention(view: view, weight: weight)
}

public func Flex(weight: CGFloat) -> PutIntention {
    return Flex(nil, weight)
}

public func Flex(view: UIView?) -> PutIntention {
    return Flex(view, 1.0)
}

public func Flex() -> PutIntention {
    return Flex(nil, 1.0)
}

public func Fix(view: UIView?, _ value: CGFloat?) -> PutIntention {
    return .FixIntention(view: view, value: value)
}

public func Fix(value: CGFloat) -> PutIntention {
    return Fix(nil, value)
}

public func Fix(view: UIView?) -> PutIntention {
    return Fix(view, nil)
}

public func Fix() -> PutIntention {
    return Fix(nil, nil)
}

private struct Dimension {
    let origin: CGFloat
    let size: CGFloat
}

private protocol BoxDimension {
    static func getDimension(rect: CGRect) -> Dimension
    static func setDimension(dimension: Dimension, inRect: CGRect) -> CGRect
}

private struct BoxWidth: BoxDimension {
    
    static func getDimension(rect: CGRect) -> Dimension {
        return Dimension(origin: rect.origin.x, size: rect.size.width)
    }
    static func setDimension(dimension: Dimension, inRect: CGRect) -> CGRect {
        var result = inRect
        result.origin.x = dimension.origin
        result.size.width = dimension.size
        return result
    }
}

private struct BoxHeight: BoxDimension {
    
    static func getDimension(rect: CGRect) -> Dimension {
        return Dimension(origin: rect.origin.y, size: rect.size.height)
    }
    static func setDimension(dimension: Dimension, inRect: CGRect) -> CGRect {
        var result = inRect
        result.origin.y = dimension.origin
        result.size.height = dimension.size
        return result
    }
}

private struct BoxLayoutOperation<T:BoxDimension> : LayoutOperation {
    let intentions: [PutIntention]
    
    init(intentions: [PutIntention]) {
        self.intentions = intentions
    }
    
    func calculateLayouts(inout layouts: [UIView : CGRect]) {
        
        var superview: UIView? = nil
        
        //search for superview first
        for i in intentions {
            
            var view: UIView? = nil
            switch (i) {
            case .FlexIntention(let v, _):
                view = v
            case .FixIntention(let v, _):
                view = v
            }
            
            if let v = view?.superview {
                assert(superview == nil || v == superview, "Layout intentions can't be calculated for views with diffferent superview")
                superview = v;
            }
        }
        
        if let superview = superview {
            
            var totalWeight: CGFloat = 0.0
            var totalSizeForFlexs: CGFloat = T.getDimension(superview.bounds).size
            
            for i in intentions {
                switch (i) {
                case .FlexIntention(_, let weight):
                    totalWeight += weight
                    break
                case .FixIntention(let view, let value):
                    if let value = value {
                        totalSizeForFlexs -= value
                    } else {
                        if let view = view {
                            totalSizeForFlexs -= T.getDimension(frameForView(view, layouts: &layouts)).size
                        }
                    }
                    break
                }
            }
            
            let unoSize = totalSizeForFlexs/totalWeight
            
            var start:CGFloat = 0
            for i in intentions {
                switch (i) {
                case .FlexIntention(let view, let weight):
                    
                    let newSize = weight * unoSize
                    
                    if let view = view {
                        let fr = frameForView(view, layouts: &layouts)
                        layouts[view] = T.setDimension(Dimension(origin: start, size: newSize), inRect: fr)
                        start += newSize
                    } else {
                        start += newSize
                    }
                    
                    totalWeight += weight
                    break
                case .FixIntention(let view, let value):
                    if let value = value {
                        if let view = view {
                            let fr = frameForView(view, layouts: &layouts)
                            layouts[view] = T.setDimension(Dimension(origin: start, size: value), inRect: fr)
                            start += value
                        } else {
                            start += value
                        }
                    } else {
                        if let view = view {
                            let fr = frameForView(view, layouts: &layouts)
                            let size = T.getDimension(frameForView(view, layouts: &layouts)).size
                            layouts[view] = T.setDimension(Dimension(origin: start, size: size), inRect: fr)
                            start += size
                        }
                    }
                    break
                }
            }
        }
    }
}

public func HPut(intentions: [PutIntention]) -> LayoutOperation {
    return BoxLayoutOperation<BoxWidth>(intentions: intentions)
}

public func VPut(intentions: [PutIntention]) -> LayoutOperation {
    return BoxLayoutOperation<BoxHeight>(intentions: intentions)
}

//MARK: width & height
private protocol DirectLayoutAction {
    static func updateRect(rect: CGRect, withValue: CGFloat) -> CGRect
}

private struct LeftDirectLayoutAction : DirectLayoutAction {
    static func updateRect(rect: CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.origin.x = withValue
        return result
    }
}

private struct TopDirectLayoutAction : DirectLayoutAction {
    static func updateRect(rect: CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.origin.y = withValue
        return result
    }
}

private struct BottomDirectLayoutAction : DirectLayoutAction {
    static func updateRect(rect: CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.origin.y = withValue - rect.size.height
        return result
    }
}

private struct RightDirectLayoutAction : DirectLayoutAction {
    static func updateRect(rect: CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.origin.x = withValue - rect.size.width
        return result
    }
}

private struct WidthDirectLayoutAction : DirectLayoutAction {
    static func updateRect(rect: CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.size.width = withValue
        return result
    }
}

private struct HeightDirectLayoutAction : DirectLayoutAction {
    static func updateRect(rect: CGRect, withValue: CGFloat) -> CGRect {
        var result = rect
        result.size.height = withValue
        return result
    }
}

private struct DirectLayoutOperation<T:DirectLayoutAction> : LayoutOperation
{
    let view: UIView?
    let value: CGFloat
    func calculateLayouts(inout layouts: [UIView : CGRect]) {
        
        guard let view = view else {
            return
        }
        
        layouts[view] = T.updateRect(frameForView(view, layouts: &layouts), withValue: value)
    }
}

public func SetX(view: UIView?, value: CGFloat) -> LayoutOperation {
    return SetLeft(view, value: value)
}

public func SetY(view: UIView?, value: CGFloat) -> LayoutOperation {
    return SetTop(view, value: value)
}

public func SetWidth(view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<WidthDirectLayoutAction>(view: view, value: value)
}

public func SetHeight(view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<HeightDirectLayoutAction>(view: view, value: value)
}

public func SetLeft(view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<LeftDirectLayoutAction>(view: view, value: value)
}

public func SetRight(view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<RightDirectLayoutAction>(view: view, value: value)
}

public func SetTop(view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<TopDirectLayoutAction>(view: view, value: value)
}

public func SetBottom(view: UIView?, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<BottomDirectLayoutAction>(view: view, value: value)
}

//MARK: size

public func SetSize(view: UIView?, width: CGFloat, height: CGFloat) -> LayoutOperation {
    return Combine( [
        SetWidth(view, value: width),
        SetHeight(view, value: height)
        ])
}

public func SetFrame(view: UIView?, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> LayoutOperation {
    return Combine( [
        SetLeft(view, value: width),
        SetTop(view, value: width),
        SetWidth(view, value: width),
        SetHeight(view, value: height)
        ])
}

//MARK: size to fit

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

private struct SizeToFitOperation: LayoutOperation {
    let view: UIView?
    let width: SizeToFitIntention
    let height: SizeToFitIntention
    
    func calculateLayouts(inout layouts: [UIView : CGRect]) {
        
        guard let view = view else {
            return
        }
        
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
        
        if case .KeepCurrent = width {
            sz.width = fr.width
        }
        
        if case .KeepCurrent = height {
            sz.height = fr.height
        }
        
        SetSize(view, width: sz.width, height: sz.height).calculateLayouts(&layouts)
    }
}

public func SizeToFit(view: UIView?, width: SizeToFitIntention, height: SizeToFitIntention) -> LayoutOperation {
    return SizeToFitOperation(view: view, width: width, height: height)
}

// same as SizeToFit(view, width: .Max, height: .Max)
public func SizeToFitMax(view: UIView?) -> LayoutOperation {
    return SizeToFit(view, width: .Max, height: .Max)
}

// same as SizeToFit(view, width: .Current, height: .Current)
public func SizeToFit(view: UIView?) -> LayoutOperation {
    return SizeToFit(view, width: .Current, height: .Current)
}


//MARK: center

public func Center(view: UIView?, insets: UIEdgeInsets) -> LayoutOperation {
    return Combine( [
        HCenter(view, leftInset: insets.left, rightInset: insets.right),
        VCenter(view, topInset: insets.top, bottomInset: insets.bottom)
        ])
}

public func Center(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return Center(view, insets: UIEdgeInsetsMake(inset, inset, inset, inset))
}

public func Center(view: UIView?) -> LayoutOperation {
    return Center(view, insets: UIEdgeInsetsZero)
}

//MARK: hcenter

public func HCenter(view: UIView?, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return HPut([Fix(leftInset), Flex(), Fix(view), Flex(), Fix(rightInset)])
}

public func HCenter(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return HCenter(view, leftInset: inset, rightInset: inset)
}

public func HCenter(view: UIView?) -> LayoutOperation {
    return HCenter(view, leftInset: 0, rightInset: 0)
}

//MARK: vcenter

public func VCenter(view: UIView?, topInset: CGFloat, bottomInset: CGFloat) -> LayoutOperation {
    return VPut([Fix(topInset), Flex(), Fix(view), Flex(), Fix(bottomInset)])
}

public func VCenter(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return VCenter(view, topInset: inset, bottomInset: inset)
}

public func VCenter(view: UIView?) -> LayoutOperation {
    return VCenter(view, topInset: 0, bottomInset: 0)}

//MARK: fill

public func Fill(view: UIView?, insets: UIEdgeInsets) -> LayoutOperation {
    return Combine( [
        HFill(view, leftInset: insets.left, rightInset: insets.right),
        VFill(view, topInset: insets.top, bottomInset: insets.bottom)
        ])
}

public func Fill(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return Fill(view, insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
}

public func Fill(view: UIView?) -> LayoutOperation {
    return Fill(view, insets: UIEdgeInsetsZero)
}

//MARK: hfill

public func HFill(view: UIView?, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return HPut([Fix(leftInset), Flex(view), Fix(rightInset)])
}

public func HFill(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return HFill(view, leftInset: inset, rightInset: inset)
}

public func HFill(view: UIView?) -> LayoutOperation {
    return HFill(view, leftInset: 0, rightInset: 0)
}

//MARK: vfill

public func VFill(view: UIView?, topInset: CGFloat, bottomInset: CGFloat) -> LayoutOperation {
    return VPut([Fix(topInset), Flex(view), Fix(bottomInset)])
}

public func VFill(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return VFill(view, topInset: inset, bottomInset: inset)
}

public func VFill(view: UIView?) -> LayoutOperation {
    return VFill(view, topInset: 0, bottomInset: 0)
}

//MARK: align top

public func AlignTop(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return VPut([Fix(inset), Fix(view), Flex()])
}

public func AlignTop(view: UIView?) -> LayoutOperation {
    return AlignTop(view, inset: 0)
}

//MARK: align left

public func AlignLeft(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return HPut([Fix(inset), Fix(view), Flex()])
}

public func AlignLeft(view: UIView?) -> LayoutOperation {
    return AlignLeft(view, inset: 0)
}

//MARK: align bottom

public func AlignBottom(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return VPut([Flex(), Fix(view), Fix(inset)])
}

public func AlignBottom(view: UIView?) -> LayoutOperation {
    return AlignBottom(view, inset: 0)
}

//MARK: align right

public func AlignRight(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return HPut([Flex(), Fix(view), Fix(inset)])
}

public func AlignRight(view: UIView?) -> LayoutOperation {
    return AlignRight(view, inset: 0)
}

//MARK: fit height fill width

public func HFillVFit(view: UIView, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return Combine([
        HFill(view, leftInset: leftInset, rightInset: rightInset),
        SizeToFit(view, width: .KeepCurrent, height: .Max),
        ])
}

public func HFillVFit(view: UIView, inset: CGFloat) -> LayoutOperation {
    return HFillVFit(view, leftInset: inset, rightInset: inset)
}

public func HFillVFit(view: UIView) -> LayoutOperation {
    return HFillVFit(view, leftInset: 0, rightInset: 0)
}

//MARK:  anchors

public protocol Anchor {
    func valueForRect(rect: CGRect) -> CGFloat
    func setValueForRect(value: CGFloat, rect: CGRect) -> CGRect
    
    var view: UIView? {get}
}

//MARK: hanchor

public enum HAnchor : Anchor {
    
    case Left(UIView?, CGFloat)
    case Center(UIView?, CGFloat)
    case Right(UIView?, CGFloat)
    
    public func valueForRect(rect: CGRect) -> CGFloat {
        switch self {
        case .Left(_, let inset):
            return CGRectGetMinX(rect) + inset
        case .Right(_, let inset):
            return CGRectGetMaxX(rect) + inset
        case .Center(_, let inset):
            return CGRectGetMidX(rect) + inset
        }
    }
    
    public func setValueForRect(value: CGFloat, rect: CGRect) -> CGRect {
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
    
    public var view: UIView? {
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

public func LeftAnchor(view: UIView?, inset: CGFloat) -> HAnchor {
    return HAnchor.Left(view, inset)
}

public func LeftAnchor(view: UIView?) -> HAnchor {
    return LeftAnchor(view, inset: 0)
}

public func RightAnchor(view: UIView?, inset: CGFloat) -> HAnchor {
    return HAnchor.Right(view, inset)
}

public func RightAnchor(view: UIView?) -> HAnchor {
    return RightAnchor(view, inset: 0)
}


public func HCenterAnchor(view: UIView?, inset: CGFloat) -> HAnchor {
    return HAnchor.Center(view, inset)
}

public func HCenterAnchor(view: UIView?) -> HAnchor {
    return HCenterAnchor(view, inset: 0)
}


//MARK: vanchor

public enum VAnchor : Anchor {
    case Top(UIView?, CGFloat)
    case Bottom(UIView?, CGFloat)
    case Center(UIView?, CGFloat)
    
    public func valueForRect(rect: CGRect) -> CGFloat {
        switch self {
        case .Top(_, let inset):
            return CGRectGetMinY(rect) + inset
        case .Bottom(_, let inset):
            return CGRectGetMaxY(rect) + inset
        case .Center(_, let inset):
            return CGRectGetMidY(rect) + inset
        }
    }
    
    public func setValueForRect(value: CGFloat, rect: CGRect) -> CGRect {
        
        var result = rect
        
        switch self {
        case .Top(_, let inset):
            result.origin.y = value - inset
        case .Bottom(_, let inset):
            result.origin.y = value - result.size.height - inset
        case .Center(_, let inset):
            result.origin.y = value - result.size.height/2 - inset
        }
        
        return result
    }
    
    public var view: UIView? {
        switch self {
        case .Top(let v, _):
            return v
        case .Bottom(let v, _):
            return v
        case .Center(let v, _):
            return v
        }
    }
}

public func TopAnchor(view: UIView?, inset: CGFloat) -> VAnchor {
    return VAnchor.Top(view, inset)
}

public func TopAnchor(view: UIView?) -> VAnchor {
    return TopAnchor(view, inset: 0)
}

public func BottomAnchor(view: UIView?, inset: CGFloat) -> VAnchor {
    return VAnchor.Bottom(view, inset)
}

public func BottomAnchor(view: UIView?) -> VAnchor {
    return BottomAnchor(view, inset: 0)
}


public func VCenterAnchor(view: UIView?, inset: CGFloat) -> VAnchor {
    return VAnchor.Center(view, inset)
}

public func VCenterAnchor(view: UIView?) -> VAnchor {
    return VCenterAnchor(view, inset: 0)
}

//MARK: follow anchor

private struct FollowOperation<T: Anchor> : LayoutOperation {
    
    let anchorToFollow: T
    let followerAnchor: T
    
    func calculateLayouts(inout layouts: [UIView : CGRect]) {
        
        guard let toFollowView = anchorToFollow.view, let followerView = followerAnchor.view else {
            return
        }
        
        assert(toFollowView.superview == followerView.superview)
        
        let anchorToFollowFrame = frameForView(toFollowView, layouts: &layouts)
        let followerAnchorFrame = frameForView(followerView, layouts: &layouts)
        
        layouts[followerView] = followerAnchor.setValueForRect(anchorToFollow.valueForRect(anchorToFollowFrame), rect: followerAnchorFrame)
    }
    
    init(anchorToFollow: T, followerAnchor: T) {
        self.anchorToFollow = anchorToFollow
        self.followerAnchor = followerAnchor
    }
    
}

// anchor.value + inset = withAnchor.value + inset

public func Follow<T: Anchor>(anchor: T, withAnchor: T) -> LayoutOperation {
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

