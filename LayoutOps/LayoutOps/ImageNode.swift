//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

open class ImageNode: AnyNode {
    
    fileprivate let image: UIImage?
    public init<T: UIImageView>(tag: Taggable, image: UIImage?, subnodes: [AnyNode] = [], initializer: @escaping (T?)->T) {
        self.image = image
        super.init(tag: tag, subnodes: subnodes) { (imageView: T?) -> T in
            let imgView = initializer(imageView)
            imgView.image = image
            return imgView
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        struct Cache {
            static let imageView = UIImageView()
        }
        Cache.imageView.image = image
        return Cache.imageView.sizeThatFits(size)
    }
}
