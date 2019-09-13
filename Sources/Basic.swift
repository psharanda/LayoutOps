//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

private func centerStart(_ value: CGFloat, superValue: CGFloat, start: CGFloat, finish: CGFloat) -> CGFloat {
    return start + (superValue - start - finish - value)/2
}

extension Layouting where Base: Layoutable {

    fileprivate func processInParent(_ block: (CGRect, CGRect)->CGRect) -> Layouting<Base> {
        
        guard let lx_parent = base.lx_parent else {
            return self
        }
        
        let superviewFrameInViewPort = lx_parent.boundsOrViewPort
        let superviewBoundsInViewPort = CGRect(x: 0, y: 0, width: superviewFrameInViewPort.width, height: superviewFrameInViewPort.height)
        
        let frame = base.lx_frame
        
        let frameInViewPort = CGRect(x: frame.origin.x - superviewFrameInViewPort.origin.x, y: frame.origin.y - superviewFrameInViewPort.origin.y, width: frame.width, height: frame.height)
        
        let rectInViewport = block(frameInViewPort, superviewBoundsInViewPort)
        
        base.updateFrame(CGRect(x: superviewFrameInViewPort.origin.x + rectInViewport.origin.x, y: superviewFrameInViewPort.origin.y + rectInViewport.origin.y, width: rectInViewport.width, height: rectInViewport.height))
        
        return self
    }
    
    #if os(macOS)
    @discardableResult
    public func center(insets: NSEdgeInsets = NSEdgeInsets()) -> Layouting<Base> {
        return center(insets: LXEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right))
    }
    #else
    @discardableResult
    public func center(insets: UIEdgeInsets = UIEdgeInsets()) -> Layouting<Base> {
        return center(insets: LXEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right))
    }
    #endif
    
    func center(insets: LXEdgeInsets = LXEdgeInsets()) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: centerStart(frame.width, superValue: superviewFrame.width, start: insets.left, finish: insets.right),
                          y: centerStart(frame.height, superValue: superviewFrame.height, start: insets.top, finish: insets.bottom),
                          width: frame.size.width,
                          height: frame.size.height)
        }
    }
    
    @discardableResult
    public func center(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Layouting<Base> {
        return center(insets: LXEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    
    @discardableResult
    public func hcenter(leftInset: CGFloat = 0, rightInset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: centerStart(frame.width, superValue: superviewFrame.width, start: leftInset, finish: rightInset),
                          y: frame.origin.y,
                          width: frame.size.width,
                          height: frame.size.height)
        }
    }
    
    @discardableResult
    public func vcenter(topInset: CGFloat = 0, bottomInset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: frame.origin.x,
                          y: centerStart(frame.height, superValue: superviewFrame.height, start: topInset, finish: bottomInset),
                          width: frame.size.width,
                          height: frame.size.height)
        }
    }
    
    
    #if os(macOS)
    @discardableResult
    public func fill(insets:NSEdgeInsets) -> Layouting<Base> {
        return fill(insets: LXEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right))
    }
    #else
    @discardableResult
    public func fill(insets: UIEdgeInsets) -> Layouting<Base> {
        return fill(insets: LXEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right))
    }
    #endif
    
    func fill(insets: LXEdgeInsets) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return LXEdgeInsetsInsetRect(superviewFrame, insets)
        }
    }
    
    @discardableResult
    public func fill(inset: CGFloat = 0) -> Layouting<Base> {
        return fill(insets: LXEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }
    
    @discardableResult
    public func fill(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Layouting<Base> {
        return fill(insets: LXEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    
    @discardableResult
    public func hfill(leftInset: CGFloat, rightInset: CGFloat) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: leftInset,
                          y: frame.origin.y,
                          width: superviewFrame.width - leftInset - rightInset,
                          height: frame.height)
        }
    }
    
    @discardableResult
    public func hfill(inset: CGFloat = 0) -> Layouting<Base> {
        return hfill(leftInset: inset, rightInset: inset)
    }
    
    @discardableResult
    public func vfill(topInset: CGFloat, bottomInset: CGFloat) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: frame.origin.x,
                          y: topInset,
                          width: frame.width,
                          height: superviewFrame.height - topInset - bottomInset)
        }
    }
    
    @discardableResult
    public func vfill(inset: CGFloat = 0) -> Layouting<Base> {
        return vfill(topInset: inset, bottomInset: inset)
    }
    
    @discardableResult
    public func alignTop(_ inset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: frame.origin.x,
                          y: inset,
                          width: frame.width,
                          height: frame.height)
        }
    }
    
    @discardableResult
    public func alignLeft(_ inset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: inset,
                          y: frame.origin.y,
                          width: frame.width,
                          height: frame.height)
        }
    }
    
    @discardableResult
    public func alignBottom(_ inset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: frame.origin.x,
                          y: superviewFrame.height - frame.height - inset,
                          width: frame.width, height: frame.height)
        }
    }
    
    @discardableResult
    public func alignRight(_ inset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: superviewFrame.width - frame.width - inset,
                          y: frame.origin.y,
                          width: frame.width,
                          height: frame.height)
        }
    }
}

extension Layouting where Base: Layoutable {
    
    @discardableResult
    fileprivate func processForSet(_ block: (CGRect)->CGRect) -> Layouting<Base> {
        base.updateFrame(block(base.lx_frame))
        return self
    }
    
    @discardableResult
    public func set(x: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
    }
    
    @discardableResult
    public func set(y: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: y, width: frame.size.width, height: frame.size.height)
        }
    }
    
    @discardableResult
    public func set(width: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.size.height)
        }
    }
    
    @discardableResult
    public func set(height: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
        }
    }
    
    @discardableResult
    public func set(left: CGFloat) -> Layouting<Base> {
        return set(x: left)
    }
    
    @discardableResult
    public func set(top: CGFloat) -> Layouting<Base> {
        return set(y: top)
    }
    
    @discardableResult
    public func set(right: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: right - frame.width, y: frame.origin.y, width: frame.width, height: frame.height)
        }
    }
    
    @discardableResult
    public func set(bottom: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: bottom - frame.height, width: frame.width, height: frame.height)
        }
    }
    
    @discardableResult
    public func set(centerX: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: centerX - frame.width/2, y: frame.height, width: frame.width, height: frame.height)
        }
    }
    
    @discardableResult
    public func set(centerY: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: centerY - frame.height/2, width: frame.width, height: frame.height)
        }
    }
    
    @discardableResult
    public func set(origin: CGPoint) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(origin: origin, size: frame.size)
        }
    }
    
    @discardableResult
    public func set(x: CGFloat, y: CGFloat) -> Layouting<Base> {
        return set(origin: CGPoint(x: x, y: y))
    }
    
    @discardableResult
    public func set(center: CGPoint) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: center.x - frame.width/2, y: center.y - frame.height/2, width: frame.width, height: frame.height)
        }
    }
    
    @discardableResult
    public func set(centerX: CGFloat, centerY: CGFloat) -> Layouting<Base> {
        return set(center: CGPoint(x: centerX, y: centerY))
    }
    
    @discardableResult
    public func set(size: CGSize) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(origin: frame.origin, size: size)
        }
    }
    
    @discardableResult
    public func set(width: CGFloat, height: CGFloat) -> Layouting<Base> {
        return set(size: CGSize(width: width, height: height))
    }
    
    @discardableResult
    public func set(frame f: CGRect) -> Layouting<Base> {
        return processForSet {frame in
            return f
        }
    }
    
    @discardableResult
    public func set(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> Layouting<Base> {
        return set(frame: CGRect(x: x, y: y, width: width, height: height))
    }
}


struct LXEdgeInsets {
    
    var top: CGFloat
    var left: CGFloat
    var bottom: CGFloat
    var right: CGFloat
    
    init() {
        self.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
}

func LXEdgeInsetsInsetRect(_ r: CGRect, _ insets: LXEdgeInsets) -> CGRect {
    var rect = r
    rect.origin.x += insets.left;
    rect.origin.y += insets.top;
    rect.size.width -= (insets.left + insets.right);
    rect.size.height -= (insets.top  + insets.bottom);
    return rect;
}

