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

protocol LayoutOperation {
    func calculateLayouts(inout layouts:[UIView: CGRect])
}

extension LayoutOperation {
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

func NOOP() -> LayoutOperation {
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

func Combine(layoutOperations: [LayoutOperation]) -> LayoutOperation {
    return CombineOperation(layoutOperations: layoutOperations)
}


enum PutIntention {

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
    
    func when(condition: (Void) -> Bool) -> PutIntention {
        if condition() {
            return self
        } else {
            return Fix() //in fact NOP
        }
    }
}

//MARK: PutIntention shorthands
func Flex(view: UIView?, _ weight: CGFloat) -> PutIntention {
    return .FlexIntention(view: view, weight: weight)
}

func Flex(weight: CGFloat) -> PutIntention {
    return Flex(nil, weight)
}

func Flex(view: UIView?) -> PutIntention {
    return Flex(view, 1.0)
}

func Flex() -> PutIntention {
    return Flex(nil, 1.0)
}

func Fix(view: UIView?, _ value: CGFloat?) -> PutIntention {
    return .FixIntention(view: view, value: value)
}

func Fix(weight: CGFloat) -> PutIntention {
    return Fix(nil, weight)
}

func Fix(view: UIView?) -> PutIntention {
    return Fix(view, nil)
}

func Fix() -> PutIntention {
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

func HPut(intentions: [PutIntention]) -> LayoutOperation {
    return BoxLayoutOperation<BoxWidth>(intentions: intentions)
}

func VPut(intentions: [PutIntention]) -> LayoutOperation {
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
    let view: UIView
    let value: CGFloat
    func calculateLayouts(inout layouts: [UIView : CGRect]) {
        layouts[view] = T.updateRect(frameForView(view, layouts: &layouts), withValue: value)
    }
}

func SetWidth(view: UIView, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<WidthDirectLayoutAction>(view: view, value: value)
}

func SetHeight(view: UIView, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<HeightDirectLayoutAction>(view: view, value: value)
}

func SetLeft(view: UIView, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<LeftDirectLayoutAction>(view: view, value: value)
}

func SetRight(view: UIView, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<RightDirectLayoutAction>(view: view, value: value)
}

func SetTop(view: UIView, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<TopDirectLayoutAction>(view: view, value: value)
}

func SetBottom(view: UIView, value: CGFloat) -> LayoutOperation {
    return DirectLayoutOperation<BottomDirectLayoutAction>(view: view, value: value)
}

//MARK: size

func SetSize(view: UIView, width: CGFloat, height: CGFloat) -> LayoutOperation {
    return Combine( [
        SetWidth(view, value: width),
        SetHeight(view, value: height)
        ])
}

func SizeToFit(view: UIView, size: CGSize) -> LayoutOperation {
    let sz = view.sizeThatFits(size)
    return SetSize(view, width: sz.width, height: sz.height)
}

func SizeToFit(view: UIView) -> LayoutOperation {
    return SizeToFit(view, size: CGSize(width: CGFloat.max, height: CGFloat.max))
}

//MARK: center

func Center(view: UIView?, insets: UIEdgeInsets) -> LayoutOperation {
    return Combine( [
        HCenter(view, leftInset: insets.left, rightInset: insets.right),
        VCenter(view, topInset: insets.top, bottomInset: insets.bottom)
        ])
}

func Center(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return Center(view, insets: UIEdgeInsetsMake(inset, inset, inset, inset))
}

func Center(view: UIView?) -> LayoutOperation {
    return Center(view, insets: UIEdgeInsetsZero)
}

//MARK: hcenter

func HCenter(view: UIView?, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return HPut([Fix(leftInset), Flex(), Fix(view), Flex(), Fix(rightInset)])
}

func HCenter(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return HCenter(view, leftInset: inset, rightInset: inset)
}

func HCenter(view: UIView?) -> LayoutOperation {
    return HCenter(view, leftInset: 0, rightInset: 0)
}

//MARK: vcenter

func VCenter(view: UIView?, topInset: CGFloat, bottomInset: CGFloat) -> LayoutOperation {
    return VPut([Fix(topInset), Flex(), Fix(view), Flex(), Fix(bottomInset)])
}

func VCenter(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return VCenter(view, topInset: inset, bottomInset: inset)
}

func VCenter(view: UIView?) -> LayoutOperation {
    return VCenter(view, topInset: 0, bottomInset: 0)}

//MARK: fill

func Fill(view: UIView?, insets: UIEdgeInsets) -> LayoutOperation {
    return Combine( [
        HFill(view, leftInset: insets.left, rightInset: insets.right),
        VFill(view, topInset: insets.top, bottomInset: insets.bottom)
        ])
}

func Fill(view: UIView?) -> LayoutOperation {
    return Fill(view, insets: UIEdgeInsetsZero)
}

//MARK: hfill

func HFill(view: UIView?, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return HPut([Fix(leftInset), Flex(view), Fix(rightInset)])
}

func HFill(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return HFill(view, leftInset: inset, rightInset: inset)
}

func HFill(view: UIView?) -> LayoutOperation {
    return HFill(view, leftInset: 0, rightInset: 0)
}

//MARK: vfill

func VFill(view: UIView?, topInset: CGFloat, bottomInset: CGFloat) -> LayoutOperation {
    return VPut([Fix(topInset), Flex(view), Fix(bottomInset)])
}

func VFill(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return VFill(view, topInset: inset, bottomInset: inset)
}

func VFill(view: UIView?) -> LayoutOperation {
    return VFill(view, topInset: 0, bottomInset: 0)
}

//MARK: align top

func AlignTop(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return VPut([Fix(inset), Fix(view), Flex()])
}

func AlignTop(view: UIView?) -> LayoutOperation {
    return AlignTop(view, inset: 0)
}

//MARK: align left

func AlignLeft(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return HPut([Fix(inset), Fix(view), Flex()])
}

func AlignLeft(view: UIView?) -> LayoutOperation {
    return AlignLeft(view, inset: 0)
}

//MARK: align bottom

func AlignBottom(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return VPut([Flex(), Fix(view), Fix(inset)])
}

func AlignBottom(view: UIView?) -> LayoutOperation {
    return AlignBottom(view, inset: 0)
}

//MARK: align right

func AlignRight(view: UIView?, inset: CGFloat) -> LayoutOperation {
    return HPut([Flex(), Fix(view), Fix(inset)])
}

func AlignRight(view: UIView?) -> LayoutOperation {
    return AlignRight(view, inset: 0)
}

//MARK: fit height fill width

func HFillVFit(view: UIView, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return Combine([
        SizeToFit(view),
        HFill(view, leftInset: leftInset, rightInset: rightInset)
    ])
}

func HFillVFit(view: UIView, inset: CGFloat) -> LayoutOperation {
    return HFillVFit(view, leftInset: inset, rightInset: inset)
}

func HFillVFit(view: UIView) -> LayoutOperation {
    return HFillVFit(view, leftInset: 0, rightInset: 0)
}

//MARK:  anchors

protocol Anchor {
    func valueForRect(rect: CGRect) -> CGFloat
    func setValueForRect(value: CGFloat, rect: CGRect, inset: CGFloat) -> CGRect
    
    var view: UIView {get}
}

//MARK: hanchor

enum HAnchor : Anchor {
    
    case Left(UIView)
    case Right(UIView)
    
    func valueForRect(rect: CGRect) -> CGFloat {
        switch self {
        case .Left(_):
            return CGRectGetMinX(rect)
        case .Right(_):
            return CGRectGetMaxX(rect)
        }
    }
    
    func setValueForRect(value: CGFloat, rect: CGRect, inset: CGFloat) -> CGRect {
        var result = rect
        switch self {
        case .Left(_):
            result.origin.x = value + inset
        case .Right(_):
            result.origin.x = value - result.size.width - inset
        }
        
        return result
    }
    
    var view: UIView {
        switch self {
        case .Left(let v):
            return v
        case .Right(let v):
            return v
        }
    }
}

//MARK: vanchor

enum VAnchor : Anchor {
    case Top(UIView)
    case Bottom(UIView)
    
    func valueForRect(rect: CGRect) -> CGFloat {
        switch self {
        case .Top(_):
            return CGRectGetMinY(rect)
        case .Bottom(_):
            return CGRectGetMaxY(rect)
        }
    }
    
    func setValueForRect(value: CGFloat, rect: CGRect, inset: CGFloat) -> CGRect {
        
        var result = rect
        
        switch self {
        case .Top(_):
            result.origin.y = value + inset
        case .Bottom(_):
            result.origin.y = value - result.size.height - inset
        }
        
        return rect
    }
    
    var view: UIView {
        switch self {
        case .Top(let v):
            return v
        case .Bottom(let v):
            return v
        }
    }
}

//MARK: follow anchor

private struct FollowOperation<T: Anchor> : LayoutOperation {
    
    let anchorToFollow: T
    let followerAnchor: T
    let inset: CGFloat
    
    func calculateLayouts(inout layouts: [UIView : CGRect]) {
        
        assert(anchorToFollow.view.superview == followerAnchor.view.superview)
        
        let anchorToFollowFrame = frameForView(anchorToFollow.view, layouts: &layouts)
        let followerAnchorFrame = frameForView(followerAnchor.view, layouts: &layouts)
    
        layouts[followerAnchor.view] = followerAnchor.setValueForRect(anchorToFollow.valueForRect(anchorToFollowFrame), rect: followerAnchorFrame, inset: inset)
    }
    
    init(anchorToFollow: T, followerAnchor: T, inset: CGFloat) {
        self.anchorToFollow = anchorToFollow
        self.followerAnchor = followerAnchor
        self.inset = inset
    }
    
}

func Follow<T: Anchor>(anchor: T, withAnchor: T, inset: CGFloat) -> LayoutOperation {
    return FollowOperation(anchorToFollow: anchor, followerAnchor: withAnchor, inset: inset)
}

func Follow<T: Anchor>(anchor: T, withAnchor: T) -> LayoutOperation {
    return Follow(anchor, withAnchor: withAnchor, inset: 0)
}

