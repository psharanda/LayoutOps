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
    fileprivate func viewWithStringTag(_ stringTag: String) -> UIView? {
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
    
    open var bounds: CGRect {
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    open var frame = CGRect()
    
    open var __lx_viewport: CGRect?
    
    open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize()
    }
    
    fileprivate var subnodes: [AnyNode]
    fileprivate var supernode: AnyNode?
    
    open weak var __lx_parent: Layoutable? {
        return supernode
    }
    
    fileprivate let initializer: ((UIView?)->UIView)?
    
    fileprivate enum Tag {
        case root
        case tagged(Taggable)
    }
    
    fileprivate let tag: Tag
    
    public init<T: UIView>(tag: Taggable, subnodes: [AnyNode] = [], initializer: @escaping (T?)->T) {
        
        self.tag = .tagged(tag)
        self.initializer = {
            initializer(($0 as? T))
        }
        self.subnodes = subnodes
        
        subnodes.forEach {
            $0.supernode = self
        }
    }
    
    fileprivate init(rs: CGSize, subnodes: [AnyNode]) {
        
        self.tag = .root
        
        self.initializer = nil
        self.subnodes = subnodes
        
        self.frame = CGRect(x: 0, y: 0, width: rs.width, height: rs.height)
        
        subnodes.forEach {
            $0.supernode = self
        }
    }
    
    open func installInRootView(_ rootView: UIView) {
        
        switch tag {
        case .root:
            fatalError("RootNode can't be child")
        case .tagged(let tag):
            let realTag = tag.tag
            
            let viewWithTag = rootView.viewWithStringTag(realTag)
            
            let view = initializer!(viewWithTag)
            view.stringTag = realTag
            
            if view.superview == nil {
                rootView.addSubview(view)
            }
            
            view.frame = frame
            subnodes.forEach {
                $0.installInRootView(view)
            }
        }
    }
}

open class RootNode: AnyNode {

    public init(size: CGSize, subnodes: [AnyNode]) {
        super.init(rs: size, subnodes: subnodes)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        fatalError("RootNode is not intended to respond sizeThatFits")
    }
    
    open override func installInRootView(_ rootView: UIView) {
        subnodes.forEach {
            $0.installInRootView(rootView)
        }
    }
}

open class Node<T: UIView>: AnyNode {
    
    public override init(tag: Taggable, subnodes: [AnyNode] = [], initializer: @escaping (T?)->T) {
        super.init(tag: tag, subnodes: subnodes) { (view: T?) -> T in            
            return initializer(view)
        }
    }    
}

extension AnyNode: LayoutingCompatible { }






