//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

private func centerStart(value: CGFloat, superValue: CGFloat, start: CGFloat, finish: CGFloat) -> CGFloat {
    return start + (superValue - start - finish - value)/2
}

extension Layouting where Base: Layoutable {

    private func processInParent(block: (CGRect, CGRect)->CGRect) -> Layouting<Base> {
        
        guard let __lx_parent = base.__lx_parent else {
            return self
        }
        
        let superviewFrameInViewPort = __lx_parent.boundsOrViewPort
        let superviewBoundsInViewPort = CGRect(x: 0, y: 0, width: superviewFrameInViewPort.width, height: superviewFrameInViewPort.height)
        
        let frame = base.frame
        
        let frameInViewPort = CGRect(x: frame.origin.x - superviewFrameInViewPort.origin.x, y: frame.origin.y - superviewFrameInViewPort.origin.y, width: frame.width, height: frame.height)
        
        let rectInViewport = block(frameInViewPort, superviewBoundsInViewPort)
        
        base.updateFrame(CGRect(x: superviewFrameInViewPort.origin.x + rectInViewport.origin.x, y: superviewFrameInViewPort.origin.y + rectInViewport.origin.y, width: rectInViewport.width, height: rectInViewport.height))
        
        return self
    }
    
    public func center(insets insets: UIEdgeInsets = UIEdgeInsets()) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: centerStart(frame.width, superValue: superviewFrame.width, start: insets.left, finish: insets.right),
                          y: centerStart(frame.height, superValue: superviewFrame.height, start: insets.top, finish: insets.bottom),
                          width: frame.size.width,
                          height: frame.size.height)
        }
    }
    
    public func center(top top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Layouting<Base> {
        return center(insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    
    public func hcenter(leftInset leftInset: CGFloat = 0, rightInset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: centerStart(frame.width, superValue: superviewFrame.width, start: leftInset, finish: rightInset),
                          y: frame.origin.y,
                          width: frame.size.width,
                          height: frame.size.height)
        }
    }
    
    public func vcenter(topInset topInset: CGFloat = 0, bottomInset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: frame.origin.x,
                          y: centerStart(frame.height, superValue: superviewFrame.height, start: topInset, finish: bottomInset),
                          width: frame.size.width,
                          height: frame.size.height)
        }
    }
    
    public func fill(insets insets: UIEdgeInsets) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return UIEdgeInsetsInsetRect(superviewFrame, insets)
        }
    }
    
    public func fill(inset inset: CGFloat = 0) -> Layouting<Base> {
        return fill(insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }
    
    public func fill(top top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> Layouting<Base> {
        return fill(insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    
    public func hfill(leftInset leftInset: CGFloat, rightInset: CGFloat) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: leftInset,
                          y: frame.origin.y,
                          width: superviewFrame.width - leftInset - rightInset,
                          height: frame.height)
        }
    }
    
    public func hfill(inset inset: CGFloat = 0) -> Layouting<Base> {
        return hfill(leftInset: inset, rightInset: inset)
    }
    
    public func vfill(topInset topInset: CGFloat, bottomInset: CGFloat) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: frame.origin.x,
                          y: topInset,
                          width: frame.width,
                          height: superviewFrame.height - topInset - bottomInset)
        }
    }
    
    public func vfill(inset inset: CGFloat = 0) -> Layouting<Base> {
        return vfill(topInset: inset, bottomInset: inset)
    }
    
    public func alignTop(inset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: frame.origin.x,
                          y: inset,
                          width: frame.width,
                          height: frame.height)
        }
    }
    
    public func alignLeft(inset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: inset,
                          y: frame.origin.y,
                          width: frame.width,
                          height: frame.height)
        }
    }
    
    public func alignBottom(inset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: frame.origin.x,
                          y: superviewFrame.height - frame.height - inset,
                          width: frame.width, height: frame.height)
        }
    }
    
    public func alignRight(inset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: superviewFrame.width - frame.width - inset,
                          y: frame.origin.y,
                          width: frame.width,
                          height: frame.height)
        }
    }
}

extension Layouting where Base: Layoutable {
    
    
    private func processForSet(block: (CGRect)->CGRect) -> Layouting<Base> {
        base.updateFrame(block(base.frame))
        return self
    }
    
    
    public func set(x x: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
    }
    
    public func set(y y: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: y, width: frame.size.width, height: frame.size.height)
        }
    }
    
    public func set(width width: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.size.height)
        }
    }
    
    public func set(height height: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
        }
    }
    
    public func set(left left: CGFloat) -> Layouting<Base> {
        return set(x: left)
    }
    
    public func set(top top: CGFloat) -> Layouting<Base> {
        return set(y: top)
    }
    
    public func set(right right: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: right - frame.width, y: frame.origin.y, width: frame.width, height: frame.height)
        }
    }
    
    public func set(bottom bottom: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: bottom - frame.height, width: frame.width, height: frame.height)
        }
    }
    
    public func set(centerX centerX: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: centerX - frame.width/2, y: frame.height, width: frame.width, height: frame.height)
        }
    }
    
    public func set(centerY centerY: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: centerY - frame.height/2, width: frame.width, height: frame.height)
        }
    }
    
    public func set(origin origin: CGPoint) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(origin: origin, size: frame.size)
        }
    }
    
    public func set(x x: CGFloat, y: CGFloat) -> Layouting<Base> {
        return set(origin: CGPoint(x: x, y: y))
    }
    
    public func set(center center: CGPoint) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: center.x - frame.width/2, y: center.y - frame.height/2, width: frame.width, height: frame.height)
        }
    }
    
    public func set(centerX centerX: CGFloat, centerY: CGFloat) -> Layouting<Base> {
        return set(center: CGPoint(x: centerX, y: centerY))
    }
    
    public func set(size size: CGSize) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(origin: frame.origin, size: size)
        }
    }
    
    public func set(width width: CGFloat, height: CGFloat) -> Layouting<Base> {
        return set(size: CGSize(width: width, height: height))
    }
    
    public func set(frame f: CGRect) -> Layouting<Base> {
        return processForSet {frame in
            return f
        }
    }
    
    public func set(x x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> Layouting<Base> {
        return set(frame: CGRect(x: x, y: y, width: width, height: height))
    }
}

