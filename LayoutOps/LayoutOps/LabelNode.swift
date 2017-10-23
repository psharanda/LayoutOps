//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

private let stubLabel = UILabel()

public enum LabelNodeString {
    case regular(String?, UIFont)
    case attributed(NSAttributedString?)
}

public class LabelNode<T: UILabel>: Node<T> {
    
    public let numberOfLines: Int
    public let lineBreakMode: NSLineBreakMode
    public let textAlignment: NSTextAlignment
    public let text: LabelNodeString
    public let estimated: Bool
    
    public init(tag: TagConvertible, text: LabelNodeString, numberOfLines: Int = 1, lineBreakMode: NSLineBreakMode = .byTruncatingTail, textAlignment: NSTextAlignment = .natural,  estimated: Bool = false, subnodes: [NodeProtocol] = [], prepareForReuse: @escaping ((T)->Void) = {_ in }, initializer: @escaping (T?)->T) {
        self.text = text
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.lineBreakMode = lineBreakMode
        self.estimated = estimated
        super.init(tag: tag, subnodes: subnodes, prepareForReuse: prepareForReuse) { (label: T?) -> T in
            
            let l = initializer(label)
            switch text {
            case .attributed(let attrString):
                l.attributedText = attrString
            case .regular(let string, let font):
                l.font = font
                l.text = string
            }
            
            if estimated {
                print("[WARNING:LayoutOps:LabelNode] you should not install nodes used for estimation")
            }
            
            l.numberOfLines = numberOfLines
            l.textAlignment = textAlignment
            l.lineBreakMode = lineBreakMode
            return l
        }
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        if estimated {
            return CGSize(width:size.width, height: estimatedHeight(for: size.width))
        }
        
        switch text {
        case .attributed(let attrString):
            
            guard let attrString = attrString else {
                return .zero
            }
            
            if attrString.length == 0 {
                return .zero
            }
            
            if Thread.current.isMainThread {
                let label = preparedStubLabel()
                label.attributedText = attrString
                return label.sizeThatFits(size)
            } else {
                return attrString.fixed(with: UIFont.systemFont(ofSize: 17)).boundingSize(for: size, numberOfLines: numberOfLines, lineBreakMode: lineBreakMode)
            }
        case .regular(let string, let font):
            
            guard let string = string else {
                return .zero
            }
            
            if string.isEmpty {
                return .zero
            }
            
            if Thread.current.isMainThread {
                let label = preparedStubLabel()
                label.text = string
                label.font = font
                return label.sizeThatFits(size)
            } else {
                return NSAttributedString(string: string, attributes: [NSAttributedStringKey.font: font]).boundingSize(for: size, numberOfLines: numberOfLines, lineBreakMode: lineBreakMode)
            }
        }
    }
    
    private func preparedStubLabel() -> UILabel {
        stubLabel.attributedText = nil
        stubLabel.text = nil
        stubLabel.font = nil
        stubLabel.numberOfLines = numberOfLines
        stubLabel.textAlignment = textAlignment
        stubLabel.lineBreakMode = lineBreakMode
        return stubLabel
    }
    
    private func estimatedHeight(for width: CGFloat) -> CGFloat {
        let numberOfLettersPerLine = width/font.xHeight
        let numLines = Int(ceil(CGFloat(textLength)/numberOfLettersPerLine))

        let finalNumberOfLines = min(numLines, (numberOfLines == 0) ? Int.max : numberOfLines)

        return CGFloat(finalNumberOfLines)*font.lineHeight + CGFloat(finalNumberOfLines - 1)
    }
    
    private var textLength:Int {
        switch text {
        case .attributed(let attr):
            return attr?.string.count ?? 0
        case .regular(let s, _):
            return s?.count ?? 0
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
                font = attr?.firstCharacterFont
            case .last:
                font = attr?.lastCharacterFont
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
            return attr?.firstCharacterFont
        case .regular(_, let f):
            return f
        }
    }
}

extension NSAttributedString {
    var firstCharacterFont: UIFont? {
        if length > 0 {
            var ptr = NSRange()
            return attribute(NSAttributedStringKey.font, at: 0, effectiveRange: &ptr) as? UIFont
        } else {
            return nil
        }
    }

    var lastCharacterFont: UIFont? {
        if length > 0 {
            var ptr = NSRange()
            return attribute(NSAttributedStringKey.font, at: length - 1, effectiveRange: &ptr) as? UIFont
        } else {
            return nil
        }
    }

    var suggestedParagraphStyle: NSParagraphStyle? {
        if length > 0 {
            var ptr = NSRange()
            return attribute(NSAttributedStringKey.paragraphStyle, at: 0, effectiveRange: &ptr) as? NSParagraphStyle
        } else {
            return nil
        }
    }
}

