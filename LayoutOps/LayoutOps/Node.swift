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
}

public class Node: Layoutable {
    
    public var bounds: CGRect {
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    public var frame: CGRect = CGRect()
    
    public func sizeThatFits(size: CGSize) -> CGSize {
        return size
    }
    
    private var subnodes: [Node]
    private var supernode: Node?
    
    public weak var parent: Layoutable? {
        return supernode
    }
    
    private let initializer: ((UIView?)->UIView)?
    
    private enum Tag {
        case Root
        case Tagged(Taggable)
    }
    
    private let tag: Tag
    
    public init<T: UIView>(tag: Taggable, subnodes: [Node] = [], initializer: (T?)->T) {
        
        self.tag = .Tagged(tag)
        self.initializer = {
            initializer(($0 as? T))
        }
        self.subnodes = subnodes
        
        subnodes.forEach {
            $0.supernode = self
        }
    }
    
    private init(rs: CGSize, subnodes: [Node]) {
        
        self.tag = .Root
        
        self.initializer = nil
        self.subnodes = subnodes
        
        self.frame = CGRect(x: 0, y: 0, width: rs.width, height: rs.height)
        
        subnodes.forEach {
            $0.supernode = self
        }
    }
    
    private func installInView(rootView: UIView) {
        
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
                $0.installInView(view)
            }
            
        }
    }
}

public class RootNode: Node {
    //root node
    public init(size: CGSize, subnodes: [Node]) {
        super.init(rs: size, subnodes: subnodes)
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        fatalError("RootNode is not intended to respond sizeThatFits")
    }
    
    public func installInRootView(rootView: UIView) {
        subnodes.forEach {
            $0.installInView(rootView)
        }
    }
}







