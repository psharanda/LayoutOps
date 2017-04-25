//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public protocol Taggable {
    var tag: String {get}
}

extension Taggable where Self: RawRepresentable, Self.RawValue == String {
    public var tag: String {
        return rawValue
    }
}

extension String: Taggable {
    public var tag: String {
        return self
    }
}

private var key: UInt8 = 0

extension UIView {
    fileprivate func subviewWithStringTag(_ stringTag: String) -> UIView? {
        for v in subviews {
            if v.stringTag == stringTag {
                return v
            }
        }
        return nil
    }
    
    fileprivate var stringTag: String? {
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
    }
    
    fileprivate func _findViewWithTag(_ tag: Taggable) -> UIView? {
        if tag.tag == stringTag {
            return self
        }
        
        for v in subviews {
            if let v = v.findViewWithTag(tag) {
                return v
            }
        }
        
        return nil
    }
    
    public func findViewWithTag<T: UIView>(_ tag: Taggable) -> T? {
        return _findViewWithTag(tag).flatMap { $0 as? T }
    }
}

open class AnyNode: Layoutable {
    
    //MARK: - layoutable
    public var bounds: CGRect {
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    public var frame = CGRect()
    
    public var __lx_viewport: CGRect?
    
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize()
    }
    
    public weak var __lx_parent: Layoutable?
    
    //MARK: - state
    private var subnodes: [AnyNode]
    
    private let initializer: ((UIView?)->UIView)
    
    private let tag: Taggable
    
    public init<T: UIView>(tag: Taggable, subnodes: [AnyNode] = [], initializer: @escaping (T?)->T) {
        
        self.tag = tag
        self.initializer = {
            initializer(($0 as? T))
        }
        self.subnodes = subnodes
        
        subnodes.forEach {
            $0.__lx_parent = self
        }
    }
    
    fileprivate func install(in view: UIView) {
        let realTag = tag.tag
        
        let viewWithTag = view.subviewWithStringTag(realTag)
        
        let nodeView = initializer(viewWithTag)
        nodeView.stringTag = realTag
        
        if nodeView.superview == nil {
            view.addSubview(nodeView)
        }
        nodeView.frame = frame
        
        subnodes.forEach {
            $0.install(in: nodeView)
        }
    }
}

public final class RootNode: Layoutable {

    public var bounds: CGRect {
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    public var frame = CGRect()
    
    public var __lx_viewport: CGRect?
    
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize()
    }
    
    public weak var __lx_parent: Layoutable? {
        return nil
    }
    
    private var subnodes: [AnyNode]
    
    private let layout: (RootNode)->Void

    public init(subnodes: [AnyNode] = [], layout: @escaping (RootNode)->Void) {
        self.subnodes = subnodes        
        self.layout = layout
        
        subnodes.forEach {
            $0.__lx_parent = self
        }
    }
    
    public func install(in view: UIView) {
        if view.bounds.size != bounds.size {
            layout(for: view.bounds.size)
        }
        subnodes.forEach {
            $0.install(in: view)
        }
    }
    
    public func layout(for size: CGSize) {
        frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        layout(self)
    }
}

open class Node<T: UIView>: AnyNode {
    
    public init(tag: Taggable, subnodes: [AnyNode] = [], initializer: @escaping (T?)->T) {
        super.init(tag: tag, subnodes: subnodes) { (view: T?) -> T in            
            return initializer(view)
        }
    }    
}

extension AnyNode: LayoutingCompatible { }

extension RootNode: LayoutingCompatible { }






