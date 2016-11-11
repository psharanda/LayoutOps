//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

private func centerStart(value: CGFloat, superValue: CGFloat, start: CGFloat, finish: CGFloat) -> CGFloat {
    return start + (superValue - start - finish - value)/2
}

private struct BasicLayoutOperation: LayoutOperation {
    let view: UIView
    let processor: (UIView, CGRect, CGRect) -> CGRect
    func calculateLayouts(inout layouts: ViewLayoutMap, viewport: Viewport) {
        guard let superview = view.superview else {
            return
        }
        
        viewport.verify(superview)
        
        let superviewFrame = frameForView(superview, layouts: &layouts)
        let superviewBounds = CGRect(x: 0, y: 0, width: superviewFrame.width, height: superviewFrame.height)
        let superviewFrameInViewPort = viewport.apply(superviewBounds, layouts: layouts)
        let superviewBoundsInViewPort = CGRect(x: 0, y: 0, width: superviewFrameInViewPort.width, height: superviewFrameInViewPort.height)
        
        let frame = frameForView(view, layouts: &layouts)
        let frameInViewPort = CGRect(x: frame.origin.x - superviewFrameInViewPort.origin.x, y: frame.origin.y - superviewFrameInViewPort.origin.y, width: frame.width, height: frame.height)
        

        let rectInViewport = processor(view, frameInViewPort, superviewBoundsInViewPort)
        
        layouts[view] = CGRect(x: superviewFrameInViewPort.origin.x + rectInViewport.origin.x, y: superviewFrameInViewPort.origin.y + rectInViewport.origin.y, width: rectInViewport.width, height: rectInViewport.height)
    }
}

private struct BasicIgnoreViewportLayoutOperation: LayoutOperation {
    let view: UIView
    let processor: (CGRect) -> CGRect
    func calculateLayouts(inout layouts: ViewLayoutMap, viewport: Viewport) {
        layouts[view] = processor(frameForView(view, layouts: &layouts))
    }
}


//MARK: - center

public func Center(view: UIView, insets: UIEdgeInsets) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: centerStart(frame.width, superValue: superviewFrame.width, start: insets.left, finish: insets.right),
                      y: centerStart(frame.height, superValue: superviewFrame.height, start: insets.top, finish: insets.bottom),
                      width: frame.size.width, height: frame.size.height)
    }
}

public func Center(view: UIView) -> LayoutOperation {
    return Center(view, insets: UIEdgeInsetsZero)
}

//MARK: - hcenter

public func HCenter(view: UIView, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: centerStart(frame.width, superValue: superviewFrame.width, start: leftInset, finish: rightInset),
                      y: frame.origin.y,
                      width: frame.size.width, height: frame.size.height)
    }
}

public func HCenter(view: UIView) -> LayoutOperation {
    return HCenter(view, leftInset: 0, rightInset: 0)
}

//MARK: - vcenter

public func VCenter(view: UIView, topInset: CGFloat, bottomInset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: frame.origin.x,
                      y: centerStart(frame.height, superValue: superviewFrame.height, start: topInset, finish: bottomInset),
                      width: frame.size.width, height: frame.size.height)
    }
}

public func VCenter(view: UIView) -> LayoutOperation {
    return VCenter(view, topInset: 0, bottomInset: 0)
}


//MARK: - fill

public func Fill(view: UIView, insets: UIEdgeInsets) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return UIEdgeInsetsInsetRect(superviewFrame, insets)
    }
}

public func Fill(view: UIView, inset: CGFloat) -> LayoutOperation {
    return Fill(view, insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
}

public func Fill(view: UIView) -> LayoutOperation {
    return Fill(view, insets: UIEdgeInsetsZero)
}

//MARK: - hfill

public func HFill(view: UIView, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: leftInset, y: frame.origin.y, width: superviewFrame.width - leftInset - rightInset, height: frame.height)
    }
}

public func HFill(view: UIView, inset: CGFloat) -> LayoutOperation {
    return HFill(view, leftInset: inset, rightInset: inset)
}

public func HFill(view: UIView) -> LayoutOperation {
    return HFill(view, leftInset: 0, rightInset: 0)
}

//MARK: - vfill

public func VFill(view: UIView, topInset: CGFloat, bottomInset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: frame.origin.x, y: topInset, width: frame.width, height: superviewFrame.height - topInset - bottomInset)
    }
}

public func VFill(view: UIView, inset: CGFloat) -> LayoutOperation {
    return VFill(view, topInset: inset, bottomInset: inset)
}

public func VFill(view: UIView) -> LayoutOperation {
    return VFill(view, topInset: 0, bottomInset: 0)
}

//MARK: - align top

public func AlignTop(view: UIView, inset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: frame.origin.x, y: inset, width: frame.width, height: frame.height)
    }
}

public func AlignTop(view: UIView) -> LayoutOperation {
    return AlignTop(view, inset: 0)
}

//MARK: - align left

public func AlignLeft(view: UIView, inset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: inset, y: frame.origin.y, width: frame.width, height: frame.height)
    }
}

public func AlignLeft(view: UIView) -> LayoutOperation {
    return AlignLeft(view, inset: 0)
}

//MARK: - align bottom

public func AlignBottom(view: UIView, inset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: frame.origin.x, y: superviewFrame.height - frame.height - inset, width: frame.width, height: frame.height)
    }
}

public func AlignBottom(view: UIView) -> LayoutOperation {
    return AlignBottom(view, inset: 0)
}

//MARK: - align right

public func AlignRight(view: UIView, inset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: superviewFrame.width - frame.width - inset, y: frame.origin.y, width: frame.width, height: frame.height)
    }
}

public func AlignRight(view: UIView) -> LayoutOperation {
    return AlignRight(view, inset: 0)
}

//MARK: - x & y & width & height

public func SetX(view: UIView, value: CGFloat) -> LayoutOperation {
    return SetLeft(view, value: value)
}

public func SetY(view: UIView, value: CGFloat) -> LayoutOperation {
    return SetTop(view, value: value)
}

public func SetWidth(view: UIView, value: CGFloat) -> LayoutOperation {
    return BasicIgnoreViewportLayoutOperation(view: view) { frame in
        return CGRect(x: frame.origin.x, y: frame.origin.y, width: value, height: frame.height)
    }
}

public func SetHeight(view: UIView, value: CGFloat) -> LayoutOperation {
    return BasicIgnoreViewportLayoutOperation(view: view) { frame in
        return CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: value)
    }
}

public func SetLeft(view: UIView, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: value, y: frame.origin.y, width: frame.width, height: frame.height)
    }
}

public func SetCenterX(view: UIView, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: value - frame.width/2, y: frame.height, width: frame.width, height: frame.height)
    }
}

public func SetRight(view: UIView, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: value - frame.width, y: frame.origin.y, width: frame.width, height: frame.height)
    }
}

public func SetTop(view: UIView, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: frame.origin.x, y: value, width: frame.width, height: frame.height)
    }
}

public func SetCenterY(view: UIView, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: frame.origin.x, y: value - frame.height/2, width: frame.width, height: frame.height)
    }
}

public func SetBottom(view: UIView, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: frame.origin.x, y: value - frame.height, width: frame.width, height: frame.height)
    }
}

//MARK: - origin

public func SetOrigin(view: UIView, x: CGFloat, y: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: x, y: y, width: frame.width, height: frame.height)
    }
}

public func SetOrigin(view: UIView, point: CGPoint) -> LayoutOperation {
    return SetOrigin(view, x: point.x, y: point.y)
}

//MARK: - center

public func SetCenter(view: UIView, x: CGFloat, y: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: x - frame.width/2, y: y - frame.height/2, width: frame.width, height: frame.height)
    }
}

public func SetCenter(view: UIView, point: CGPoint) -> LayoutOperation {
    return SetCenter(view, x: point.x, y: point.y)
}

//MARK: - size

public func SetSize(view: UIView, width: CGFloat, height: CGFloat) -> LayoutOperation {
    return BasicIgnoreViewportLayoutOperation(view: view) { frame in
        return CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
    }
}

public func SetSize(view: UIView, size: CGSize) -> LayoutOperation {
    return SetSize(view, width: size.width, height: size.height)
}

//MARK: - frame

public func SetFrame(view: UIView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

public func SetFrame(view: UIView, frame: CGRect) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return frame
    }
}
