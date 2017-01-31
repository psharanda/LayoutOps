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
    private func viewWithStringTag(stringTag: String) -> UIView? {
        for v in subviews {
            if v.stringTag == stringTag {
                return v
            }
        }
        return nil
    }
    
    private var stringTag: String? {
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
    }
    
    private func _findViewWithTag(tag: Taggable) -> UIView? {
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
    
    public func findViewWithTag<T: UIView>(tag: Taggable) -> T? {
        return _findViewWithTag(tag).flatMap { $0 as? T }
    }
}

public class AnyNode: Layoutable {
    
    public var bounds: CGRect {
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    public var frame = CGRect()
    
    public var viewportInsets = UIEdgeInsets()
    
    public func sizeThatFits(size: CGSize) -> CGSize {
        return CGSize()
    }
    
    private var subnodes: [AnyNode]
    private var supernode: AnyNode?
    
    public weak var parent: Layoutable? {
        return supernode
    }
    
    private let initializer: ((UIView?)->UIView)?
    
    private enum Tag {
        case Root
        case Tagged(Taggable)
    }
    
    private let tag: Tag
    
    public init<T: UIView>(tag: Taggable, subnodes: [AnyNode] = [], initializer: (T?)->T) {
        
        self.tag = .Tagged(tag)
        self.initializer = {
            initializer(($0 as? T))
        }
        self.subnodes = subnodes
        
        subnodes.forEach {
            $0.supernode = self
        }
    }
    
    private init(rs: CGSize, subnodes: [AnyNode]) {
        
        self.tag = .Root
        
        self.initializer = nil
        self.subnodes = subnodes
        
        self.frame = CGRect(x: 0, y: 0, width: rs.width, height: rs.height)
        
        subnodes.forEach {
            $0.supernode = self
        }
    }
    
    public func installInRootView(rootView: UIView) {
        
        switch tag {
        case .Root:
            fatalError("RootNode can't be child")
        case .Tagged(let tag):
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

public class RootNode: AnyNode {

    public init(size: CGSize, subnodes: [AnyNode]) {
        super.init(rs: size, subnodes: subnodes)
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        fatalError("RootNode is not intended to respond sizeThatFits")
    }
    
    public override func installInRootView(rootView: UIView) {
        subnodes.forEach {
            $0.installInRootView(rootView)
        }
    }
}

public class Node<T: UIView>: AnyNode {
    
    public override init(tag: Taggable, subnodes: [AnyNode] = [], initializer: (T?)->T) {
        super.init(tag: tag, subnodes: subnodes) { (view: T?) -> T in            
            return initializer(view)
        }
    }    
}

extension AnyNode: LayoutingCompatible { }






