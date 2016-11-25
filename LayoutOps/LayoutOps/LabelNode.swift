//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public enum LabelNodeString {
    case Regular(String, UIFont)
    case Attributed(NSAttributedString)
}

public class LabelNode: AnyNode {
    
    private let text: LabelNodeString
    public init<T: UILabel>(tag: Taggable, text: LabelNodeString, subnodes: [AnyNode] = [], initializer: (T?)->T) {
        self.text = text
        super.init(tag: tag, subnodes: subnodes) { (label: T?) -> T in
            
            let l = initializer(label)
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
}

extension LabelNode: Baselinable {
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

extension LabelNode: LayoutableWithFont {
    public var font: UIFont! {
        switch text {
        case .Attributed(let attr):
            if attr.length > 0 {
                var ptr = NSRange()
                return attr.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: &ptr) as? UIFont
            } else {
                return nil
            }
        case .Regular(_, let f):
            return f
        }
    }
}
