//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public struct LabelNodeEstimation {
    public let length: Int
    public let font: UIFont
    public let lineSpacing: CGFloat
    public let lineHeightMultiple: CGFloat
    
    public init(length: Int, font: UIFont, numberOfLines: Int = 1, lineSpacing: CGFloat = 0, lineHeightMultiple: CGFloat = 1.2) {
        self.length = length
        self.font = font
        self.lineSpacing = lineSpacing
        self.lineHeightMultiple = lineHeightMultiple
    }
    
    public init(string: String?, font: UIFont, numberOfLines: Int = 1, lineSpacing: CGFloat = 0, lineHeightMultiple: CGFloat = 1.2) {
        self.init(length: string?.characters.count ?? 0, font: font, numberOfLines: numberOfLines, lineSpacing: lineSpacing, lineHeightMultiple: lineHeightMultiple)
    }
    
    public init(attributedString: NSAttributedString?, numberOfLines: Int = 1) {
        let ps = attributedString?.suggestedParagraphStyle
        self.init(length: attributedString?.length ?? 0, font: attributedString?.firstCharacterFont ?? UIFont.systemFont(ofSize: 12), numberOfLines: numberOfLines, lineSpacing: ps?.lineSpacing ?? 0, lineHeightMultiple:  ps?.lineHeightMultiple ?? 1)
    }
}

public enum LabelNodeString {
    case regular(String?, UIFont)
    case attributed(NSAttributedString?)
    case estimated(LabelNodeEstimation)
}

open class LabelNode<T: UILabel>: Node<T> {
    
    fileprivate let numberOfLines: Int
    fileprivate let text: LabelNodeString
    
    public init(tag: TagConvertible, text: LabelNodeString, numberOfLines: Int = 1, subnodes: [NodeProtocol] = [], prepareForReuse: @escaping ((T)->Void) = {_ in }, initializer: @escaping (T?)->T) {
        self.text = text
        self.numberOfLines = numberOfLines
        super.init(tag: tag, subnodes: subnodes, prepareForReuse: prepareForReuse) { (label: T?) -> T in
            
            let l = initializer(label)
            switch text {
            case .attributed(let attrString):
                l.attributedText = attrString
            case .regular(let string, let font):
                l.font = font
                l.text = string
            case .estimated:
                print("[WARNING:LayoutOps:LabelNode] you should not install nodes used for estimation")
            }
            l.numberOfLines = numberOfLines
            return l
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        switch text {
        case .attributed(let attrString):
            let label = stubLabel()
            label.attributedText = attrString
            return label.sizeThatFits(size)
        case .regular(let string, let font):
            let label = stubLabel()
            label.text = string
            label.font = font
            return label.sizeThatFits(size)
        case .estimated(let estimation):
            let h = estimatedHeightWithFont(estimation: estimation, width: size.width)
            return CGSize(width:size.width, height: h)
        }
    }
    
    private func stubLabel() -> UILabel {
        let label = Thread.current.cachedObject(for: "LabelNode.label") {
            return UILabel()
        }
        
        label.attributedText = nil
        label.text = nil
        label.font = nil
        label.numberOfLines = numberOfLines
        return label
    }
    
    
    private func estimatedHeightWithFont(estimation: LabelNodeEstimation, width: CGFloat) -> CGFloat {
        
        let numberOfLettersPerLine = width/font.xHeight
        let numberOfLines = Int(round(CGFloat(estimation.length)/numberOfLettersPerLine))
        
        let finalNumberOfLines = min(numberOfLines, (numberOfLines == 0) ? Int.max : numberOfLines)
        
        return CGFloat(finalNumberOfLines)*font.lineHeight*estimation.lineHeightMultiple + CGFloat(finalNumberOfLines - 1)*estimation.lineSpacing
        
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
        case .estimated(let estimation):
            font = estimation.font
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
        case .estimated(let estimation):
            return estimation.font
        }
    }
}

extension NSAttributedString {
    var firstCharacterFont: UIFont? {
        if length > 0 {
            var ptr = NSRange()
            return attribute(NSFontAttributeName, at: 0, effectiveRange: &ptr) as? UIFont
        } else {
            return nil
        }
    }
    
    var lastCharacterFont: UIFont? {
        if length > 0 {
            var ptr = NSRange()
            return attribute(NSFontAttributeName, at: length - 1, effectiveRange: &ptr) as? UIFont
        } else {
            return nil
        }
    }
    
    var suggestedParagraphStyle: NSParagraphStyle? {
        if length > 0 {
            var ptr = NSRange()
            return attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: &ptr) as? NSParagraphStyle
        } else {
            return nil
        }
    }
}
