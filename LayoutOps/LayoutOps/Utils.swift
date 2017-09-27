//
//  Utils.swift
//  LayoutOps
//
//  Created by Pavel Sharanda on 24.02.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    /// Returns a new NSAttributedString with a given font and the same attributes.
    func fixed(with font: UIFont) -> NSAttributedString {
        let fontAttribute = [NSFontAttributeName: font]
        let attributedTextWithFont = NSMutableAttributedString(string: string, attributes: fontAttribute)
        let fullRange = NSMakeRange(0, string.count)
        attributedTextWithFont.beginEditing()
        self.enumerateAttributes(in: fullRange, options: .longestEffectiveRangeNotRequired, using: { (attributes, range, _) in
            
            var a = attributes
            if let p = attributes[NSParagraphStyleAttributeName] as? NSParagraphStyle, p.lineBreakMode != .byWordWrapping {
                let newStyle: NSMutableParagraphStyle = p.mutableCopy() as! NSMutableParagraphStyle
                newStyle.lineBreakMode = .byWordWrapping
                a[NSParagraphStyleAttributeName] = newStyle
            }
            
            attributedTextWithFont.addAttributes(a, range: range)
        })
        attributedTextWithFont.endEditing()
        
        return attributedTextWithFont
    }
    
    func boundingSize(for size: CGSize, numberOfLines: Int) -> CGSize {
        let textContainer = NSTextContainer(size: size)
        textContainer.maximumNumberOfLines = numberOfLines
        
        let textStorage = NSTextStorage(attributedString: self)
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        textStorage.addLayoutManager(layoutManager)
        
        return layoutManager.usedRect(for: textContainer).size
    }
}

func isAlmostEqual(left: CGFloat, right: CGFloat) -> Bool
{
    return fabs(left.distance(to: right)) <= 1e-3
}

func isAlmostEqual(left: CGSize, right: CGSize) -> Bool
{
    return isAlmostEqual(left: left.width, right: right.width) && isAlmostEqual(left: left.height, right: right.height)
}
