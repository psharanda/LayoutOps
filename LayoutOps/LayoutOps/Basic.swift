//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

private struct BasicLayoutOperation: LayoutOperation {
    let view: Layoutable
    let processor: (Layoutable, CGRect, CGRect) -> CGRect
    func calculateLayouts(inout layouts: ViewLayoutMap, viewport: Viewport) {
        guard let superview = view.parent else {
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
    let view: Layoutable
    let processor: (CGRect) -> CGRect
    func calculateLayouts(inout layouts: ViewLayoutMap, viewport: Viewport) {
        layouts[view] = processor(frameForView(view, layouts: &layouts))
    }
}


//MARK: - center

public func Center(view: Layoutable, insets: UIEdgeInsets) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: centerStart(frame.width, superValue: superviewFrame.width, start: insets.left, finish: insets.right),
                      y: centerStart(frame.height, superValue: superviewFrame.height, start: insets.top, finish: insets.bottom),
                      width: frame.size.width, height: frame.size.height)
    }
}

public func Center(view: Layoutable) -> LayoutOperation {
    return Center(view, insets: UIEdgeInsetsZero)
}

//MARK: - hcenter

public func HCenter(view: Layoutable, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: centerStart(frame.width, superValue: superviewFrame.width, start: leftInset, finish: rightInset),
                      y: frame.origin.y,
                      width: frame.size.width, height: frame.size.height)
    }
}

public func HCenter(view: Layoutable) -> LayoutOperation {
    return HCenter(view, leftInset: 0, rightInset: 0)
}

//MARK: - vcenter

public func VCenter(view: Layoutable, topInset: CGFloat, bottomInset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: frame.origin.x,
                      y: centerStart(frame.height, superValue: superviewFrame.height, start: topInset, finish: bottomInset),
                      width: frame.size.width, height: frame.size.height)
    }
}

public func VCenter(view: Layoutable) -> LayoutOperation {
    return VCenter(view, topInset: 0, bottomInset: 0)
}


//MARK: - fill

public func Fill(view: Layoutable, insets: UIEdgeInsets) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return UIEdgeInsetsInsetRect(superviewFrame, insets)
    }
}

public func Fill(view: Layoutable, inset: CGFloat) -> LayoutOperation {
    return Fill(view, insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
}

public func Fill(view: Layoutable) -> LayoutOperation {
    return Fill(view, insets: UIEdgeInsetsZero)
}

//MARK: - hfill

public func HFill(view: Layoutable, leftInset: CGFloat, rightInset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: leftInset, y: frame.origin.y, width: superviewFrame.width - leftInset - rightInset, height: frame.height)
    }
}

public func HFill(view: Layoutable, inset: CGFloat) -> LayoutOperation {
    return HFill(view, leftInset: inset, rightInset: inset)
}

public func HFill(view: Layoutable) -> LayoutOperation {
    return HFill(view, leftInset: 0, rightInset: 0)
}

//MARK: - vfill

public func VFill(view: Layoutable, topInset: CGFloat, bottomInset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: frame.origin.x, y: topInset, width: frame.width, height: superviewFrame.height - topInset - bottomInset)
    }
}

public func VFill(view: Layoutable, inset: CGFloat) -> LayoutOperation {
    return VFill(view, topInset: inset, bottomInset: inset)
}

public func VFill(view: Layoutable) -> LayoutOperation {
    return VFill(view, topInset: 0, bottomInset: 0)
}

//MARK: - align top

public func AlignTop(view: Layoutable, inset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: frame.origin.x, y: inset, width: frame.width, height: frame.height)
    }
}

public func AlignTop(view: Layoutable) -> LayoutOperation {
    return AlignTop(view, inset: 0)
}

//MARK: - align left

public func AlignLeft(view: Layoutable, inset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: inset, y: frame.origin.y, width: frame.width, height: frame.height)
    }
}

public func AlignLeft(view: Layoutable) -> LayoutOperation {
    return AlignLeft(view, inset: 0)
}

//MARK: - align bottom

public func AlignBottom(view: Layoutable, inset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: frame.origin.x, y: superviewFrame.height - frame.height - inset, width: frame.width, height: frame.height)
    }
}

public func AlignBottom(view: Layoutable) -> LayoutOperation {
    return AlignBottom(view, inset: 0)
}

//MARK: - align right

public func AlignRight(view: Layoutable, inset: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { view, frame, superviewFrame in
        return CGRect(x: superviewFrame.width - frame.width - inset, y: frame.origin.y, width: frame.width, height: frame.height)
    }
}

public func AlignRight(view: Layoutable) -> LayoutOperation {
    return AlignRight(view, inset: 0)
}

//MARK: - x & y & width & height

public func SetX(view: Layoutable, value: CGFloat) -> LayoutOperation {
    return SetLeft(view, value: value)
}

public func SetY(view: Layoutable, value: CGFloat) -> LayoutOperation {
    return SetTop(view, value: value)
}

public func SetWidth(view: Layoutable, value: CGFloat) -> LayoutOperation {
    return BasicIgnoreViewportLayoutOperation(view: view) { frame in
        return CGRect(x: frame.origin.x, y: frame.origin.y, width: value, height: frame.height)
    }
}

public func SetHeight(view: Layoutable, value: CGFloat) -> LayoutOperation {
    return BasicIgnoreViewportLayoutOperation(view: view) { frame in
        return CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: value)
    }
}

public func SetLeft(view: Layoutable, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: value, y: frame.origin.y, width: frame.width, height: frame.height)
    }
}

public func SetCenterX(view: Layoutable, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: value - frame.width/2, y: frame.height, width: frame.width, height: frame.height)
    }
}

public func SetRight(view: Layoutable, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: value - frame.width, y: frame.origin.y, width: frame.width, height: frame.height)
    }
}

public func SetTop(view: Layoutable, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: frame.origin.x, y: value, width: frame.width, height: frame.height)
    }
}

public func SetCenterY(view: Layoutable, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: frame.origin.x, y: value - frame.height/2, width: frame.width, height: frame.height)
    }
}

public func SetBottom(view: Layoutable, value: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: frame.origin.x, y: value - frame.height, width: frame.width, height: frame.height)
    }
}

//MARK: - origin

public func SetOrigin(view: Layoutable, x: CGFloat, y: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: x, y: y, width: frame.width, height: frame.height)
    }
}

public func SetOrigin(view: Layoutable, point: CGPoint) -> LayoutOperation {
    return SetOrigin(view, x: point.x, y: point.y)
}

//MARK: - center

public func SetCenter(view: Layoutable, x: CGFloat, y: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: x - frame.width/2, y: y - frame.height/2, width: frame.width, height: frame.height)
    }
}

public func SetCenter(view: Layoutable, point: CGPoint) -> LayoutOperation {
    return SetCenter(view, x: point.x, y: point.y)
}

//MARK: - size

public func SetSize(view: Layoutable, width: CGFloat, height: CGFloat) -> LayoutOperation {
    return BasicIgnoreViewportLayoutOperation(view: view) { frame in
        return CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: height)
    }
}

public func SetSize(view: Layoutable, size: CGSize) -> LayoutOperation {
    return SetSize(view, width: size.width, height: size.height)
}

//MARK: - frame

public func SetFrame(view: Layoutable, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

public func SetFrame(view: Layoutable, frame: CGRect) -> LayoutOperation {
    return BasicLayoutOperation(view: view) { _, frame, _ in
        return frame
    }
}

/************************************************************************************/
/*[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]*/
/************************************************************************************/

private func centerStart(value: CGFloat, superValue: CGFloat, start: CGFloat, finish: CGFloat) -> CGFloat {
    return start + (superValue - start - finish - value)/2
}

extension Layouting where Base: Layoutable {
    
    
    private func processInParent(block: (CGRect, CGRect)->CGRect) -> Layouting<Base> {
        
        guard let parent = base.parent else {
            return self
        }
        
        base.updateFrame(block(base.frame, parent.frame))
        
        return self
    }
    
    public func center(insets: UIEdgeInsets = UIEdgeInsets()) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: centerStart(frame.width, superValue: superviewFrame.width, start: insets.left, finish: insets.right),
                          y: centerStart(frame.height, superValue: superviewFrame.height, start: insets.top, finish: insets.bottom),
                          width: frame.size.width,
                          height: frame.size.height)
        }
    }
    
    public func hcenter(leftInset: CGFloat = 0, rightInset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: centerStart(frame.width, superValue: superviewFrame.width, start: leftInset, finish: rightInset),
                          y: frame.origin.y,
                          width: frame.size.width,
                          height: frame.size.height)
        }
    }
    
    public func vcenter(topInset: CGFloat = 0, bottomInset: CGFloat = 0) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: frame.origin.x,
                          y: centerStart(frame.height, superValue: superviewFrame.height, start: topInset, finish: bottomInset),
                          width: frame.size.width,
                          height: frame.size.height)
        }
    }
    
    public func fill(insets: UIEdgeInsets) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return UIEdgeInsetsInsetRect(superviewFrame, insets)
        }
    }
    
    public func fill(inset: CGFloat = 0) -> Layouting<Base> {
        return fill(UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }
    
    public func hfill(leftInset: CGFloat, rightInset: CGFloat) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: leftInset,
                          y: frame.origin.y,
                          width: superviewFrame.width - leftInset - rightInset,
                          height: frame.height)
        }
    }
    
    public func hfill(inset: CGFloat = 0) -> Layouting<Base> {
        return hfill(inset, rightInset: inset)
    }
    
    public func vfill(topInset: CGFloat, bottomInset: CGFloat) -> Layouting<Base> {
        return processInParent { frame, superviewFrame in
            return CGRect(x: frame.origin.x,
                          y: topInset,
                          width: frame.width,
                          height: superviewFrame.height - topInset - bottomInset)
        }
    }
    
    public func vfill(inset: CGFloat = 0) -> Layouting<Base> {
        return vfill(inset, bottomInset: inset)
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
    
    
    public func setX(value: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: value, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
    }
    
    public func setY(value: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: value, width: frame.size.width, height: frame.size.height)
        }
    }
    
    public func setWidth(value: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: frame.origin.y, width: value, height: frame.size.height)
        }
    }
    
    public func setHeight(value: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: value)
        }
    }
    
    public func setLeft(value: CGFloat) -> Layouting<Base> {
        return setX(value)
    }
    
    public func setTop(value: CGFloat) -> Layouting<Base> {
        return setY(value)
    }
    
    public func setRight(value: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: value - frame.width, y: frame.origin.y, width: frame.width, height: frame.height)
        }
    }
    
    public func setBottom(value: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: value - frame.height, width: frame.width, height: frame.height)
        }
    }
    
    public func setCenterX(value: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: value - frame.width/2, y: frame.height, width: frame.width, height: frame.height)
        }
    }
    
    public func setCenterY(value: CGFloat) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: frame.origin.x, y: value - frame.height/2, width: frame.width, height: frame.height)
        }
    }
    
    public func setOrigin(value: CGPoint) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(origin: value, size: frame.size)
        }
    }
    
    public func setOrigin(x: CGFloat, y: CGFloat) -> Layouting<Base> {
        return setOrigin(CGPoint(x: x, y: y))
    }
    
    public func setCenter(value: CGPoint) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(x: value.x - frame.width/2, y: value.y - frame.height/2, width: frame.width, height: frame.height)
        }
    }
    
    public func setCenter(x: CGFloat, y: CGFloat) -> Layouting<Base> {
        return setCenter(CGPoint(x: x, y: y))
    }
    
    public func setSize(value: CGSize) -> Layouting<Base> {
        return processForSet {frame in
            return CGRect(origin: frame.origin, size: value)
        }
    }
    
    public func setSize(width: CGFloat, height: CGFloat) -> Layouting<Base> {
        return setSize(CGSize(width: width, height: height))
    }
    
    public func setFrame(value: CGRect) -> Layouting<Base> {
        return processForSet {frame in
            return value
        }
    }
    
    public func setFrame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> Layouting<Base> {
        return setFrame(CGRect(x: x, y: y, width: width, height: height))
    }
}

