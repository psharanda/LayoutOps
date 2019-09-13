//
//  Created by Pavel Sharanda on 24.02.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

#if os(iOS)
import UIKit

#if swift(>=4.2)
 typealias AttributedStringKey = NSAttributedString.Key
#else
 typealias AttributedStringKey = NSAttributedStringKey
#endif

extension NSAttributedString {
    
    /// Returns a new NSAttributedString with a given font and the same attributes.
    func fixed(with font: UIFont) -> NSAttributedString {
        let fontAttribute = [AttributedStringKey.font: font]
        let attributedTextWithFont = NSMutableAttributedString(string: string, attributes: fontAttribute)
        let fullRange = NSMakeRange(0, string.count)
        attributedTextWithFont.beginEditing()
        self.enumerateAttributes(in: fullRange, options: .longestEffectiveRangeNotRequired, using: { (attributes, range, _) in
            
            var a = attributes
            if let p = attributes[AttributedStringKey.paragraphStyle] as? NSParagraphStyle, p.lineBreakMode != .byWordWrapping {
                let newStyle: NSMutableParagraphStyle = p.mutableCopy() as! NSMutableParagraphStyle
                newStyle.lineBreakMode = .byWordWrapping
                a[AttributedStringKey.paragraphStyle] = newStyle
            }
            
            attributedTextWithFont.addAttributes(a, range: range)
        })
        attributedTextWithFont.endEditing()
        
        return attributedTextWithFont
    }
    
    func boundingSize(for size: CGSize, numberOfLines: Int, lineBreakMode: NSLineBreakMode) -> CGSize {
        let textContainer = NSTextContainer(size: size)
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        
        let layoutManager = NSLayoutManager()
        //TODO: investigate this
        //layoutManager.usesFontLeading = false
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)
        textStorage.setAttributedString(self)
        
        return layoutManager.usedRect(for: textContainer).size
    }
}

#endif

