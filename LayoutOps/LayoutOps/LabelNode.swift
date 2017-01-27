//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public enum LabelNodeString {
    case regular(String?, UIFont)
    case attributed(NSAttributedString?)
}

open class LabelNode: AnyNode {
    
    fileprivate let numberOfLines: Int
    fileprivate let text: LabelNodeString
    public init<T: UILabel>(tag: Taggable, text: LabelNodeString, numberOfLines: Int = 1, subnodes: [AnyNode] = [], initializer: @escaping (T?)->T) {
        self.text = text
        self.numberOfLines = numberOfLines
        super.init(tag: tag, subnodes: subnodes) { (label: T?) -> T in
            
            let l = initializer(label)
            switch text {
            case .attributed(let attrString):
                l.attributedText = attrString
            case .regular(let string, let font):
                l.font = font
                l.text = string
            }
            l.numberOfLines = numberOfLines
            return l
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        struct Cache {
            static let label = UILabel()
        }
        
        Cache.label.attributedText = nil
        Cache.label.text = nil
        Cache.label.font = nil
        Cache.label.numberOfLines = numberOfLines
        
        switch text {
        case .attributed(let attrString):
            Cache.label.attributedText = attrString
            return Cache.label.sizeThatFits(size)
        case .regular(let string, let font):
            Cache.label.text = string
            Cache.label.font = font
            return Cache.label.sizeThatFits(size)
        }
    }
}

extension LabelNode: Baselinable {
    public func baselineValueOfType(_ type: BaselineType, size: CGSize) -> CGFloat {
        let sz = sizeThatFits(size)
        var font: UIFont?
        
        switch text {
        case .attributed(let attr):
            switch type {
            case .first:
                var ptr = NSRange()
                if let attr = attr, attr.length > 0 {
                    font = attr.attribute(NSFontAttributeName, at: 0, effectiveRange: &ptr) as? UIFont
                }
            case .last:
                var ptr = NSRange()
                if let attr = attr, attr.length > 0 {
                    font = attr.attribute(NSFontAttributeName, at: attr.length - 1, effectiveRange: &ptr) as? UIFont
                }
            }
        case .regular(_, let f):
            font = f
        }
        
        switch type {
        case .first:
            return (size.height - sz.height)/2 + (font?.ascender ?? 0)
        case .last:
            return size.height - (size.height - sz.height)/2 + (font?.descender ?? 0)
        }
    }
}

extension LabelNode: LayoutableWithFont {
    public var font: UIFont! {
        switch text {
        case .attributed(let attr):
            if let attr = attr, attr.length > 0 {
                var ptr = NSRange()
                return attr.attribute(NSFontAttributeName, at: 0, effectiveRange: &ptr) as? UIFont
            } else {
                return nil
            }
        case .regular(_, let f):
            return f
        }
    }
}
