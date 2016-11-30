//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public enum LabelNodeString {
    case Regular(String?, UIFont)
    case Attributed(NSAttributedString?)
}

public class LabelNode: AnyNode {
    
    private let numberOfLines: Int
    private let text: LabelNodeString
    public init<T: UILabel>(tag: Taggable, text: LabelNodeString, numberOfLines: Int = 1, subnodes: [AnyNode] = [], initializer: (T?)->T) {
        self.text = text
        self.numberOfLines = numberOfLines
        super.init(tag: tag, subnodes: subnodes) { (label: T?) -> T in
            
            let l = initializer(label)
            switch text {
            case .Attributed(let attrString):
                l.attributedText = attrString
            case .Regular(let string, let font):
                l.font = font
                l.text = string
            }
            l.numberOfLines = numberOfLines
            return l
        }
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        
        struct Cache {
            static let label = UILabel()
        }
        
        Cache.label.attributedText = nil
        Cache.label.text = nil
        Cache.label.font = nil
        Cache.label.numberOfLines = numberOfLines
        
        switch text {
        case .Attributed(let attrString):
            Cache.label.attributedText = attrString
            return Cache.label.sizeThatFits(size)
        case .Regular(let string, let font):
            Cache.label.text = string
            Cache.label.font = font
            return Cache.label.sizeThatFits(size)
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
                if let attr = attr where attr.length > 0 {
                    font = attr.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: &ptr) as? UIFont
                }
            case .Last:
                var ptr = NSRange()
                if let attr = attr where attr.length > 0 {
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
            if let attr = attr where attr.length > 0 {
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
