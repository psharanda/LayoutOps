//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

public protocol Taggable {
    var tag: Int {get}
}

extension Taggable where Self: RawRepresentable, Self.RawValue == Int {
    public var tag: Int {
        return rawValue
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
    
    private let initializer: ((NodeBox)->UIView)?
    
    private enum Tag {
        case Root
        case Tagged(Taggable)
    }
    
    private let tag: Tag
    
    public init(tag: Taggable, subnodes: [Node] = [], initializer: (NodeBox)->UIView) {
        
        self.tag = .Tagged(tag)
        self.initializer = initializer
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
    
    public func installInRootView(rootView: UIView) {
        
        switch tag {
        case .Root:
            subnodes.forEach {
                $0.installInRootView(rootView)
            }
        case .Tagged(let tag):
            
            let realTag = tag.tag + 1
            
            let viewWithTag = rootView.viewWithTag(realTag)
            
            let view = initializer!(NodeBox(view: viewWithTag))
            view.tag = realTag
            
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


public enum LabelNodeString {
    case Regular(String, UIFont)
    case Attributed(NSAttributedString)
}

public class RootNode: Node {
    //root node
    public init(size: CGSize, subnodes: [Node]) {
        super.init(rs: size, subnodes: subnodes)
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        fatalError("RootNode is not intended to respond sizeThatFits")
    }
}

public class LabelNode: Node, Baselinable {
    
    private let text: LabelNodeString    
    public init(tag: Taggable, text: LabelNodeString, subnodes: [Node] = [], initializer: (NodeBox)->UILabel) {
        self.text = text
        super.init(tag: tag, subnodes: subnodes) {
            let l = initializer($0)
            
            switch text {
            case .Attributed(let attrString):
                l.attributedText = attrString
            case .Regular(let string, let font):
                l.font = font
                l.text = string
            }
            return l
        }
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        
        switch text {
        case .Attributed(let attrString):
            return attrString.boundingRectWithSize(size, options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil).size
        case .Regular(let string, let font):
            return (string as NSString).boundingRectWithSize(size, options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName: font], context: nil).size
        }
    }
    
    public func baselineValueOfType(type: BaselineType, size: CGSize) -> CGFloat {
        let sz = sizeThatFits(size)
        var font: UIFont?
        
        switch text {
        case .Attributed(let attr):
            switch type {
            case .First:
                var ptr = NSRange()
                if attr.length > 0 {
                    font = attr.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: &ptr) as? UIFont
                }
            case .Last:
                var ptr = NSRange()
                if attr.length > 0 {
                    font = attr.attribute(NSFontAttributeName, atIndex: attr.length - 1, effectiveRange: &ptr) as? UIFont
                }
            }
        case .Regular(_, let f):
            font = f
        }
        
        switch type {
        case .First:
            return (size.height - sz.height)/2 + (font?.ascender ?? 0)
        case .Last:
            return size.height - (size.height - sz.height)/2 + (font?.descender ?? 0)
        }
    }
}



public class ImageNode: Node {
    
    private let image: UIImage
    public init(tag: Taggable, image: UIImage, subnodes: [Node] = [], initializer: (NodeBox)->UIImageView) {
        self.image = image
        super.init(tag: tag, subnodes: subnodes) {
            let imageView = initializer($0)
            imageView.image = image
            return imageView
        }
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return image.size
    }
}

public struct NodeBox {
    private let view: UIView?
    private init(view: UIView?) {
        self.view  = view
    }
    
    public func dequeue<T: UIView>() -> T {
        
        if let view = view as? T {
            return view
        } else {
            return T()
        }
    }
}

