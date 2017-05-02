//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

open class ImageNode<T: UIImageView>: Node<T> {
    
    private let image: UIImage?
    
    public init(tag: TagConvertible, image: UIImage?, subnodes: [NodeProtocol] = [], initializer: @escaping (T?)->T) {
        self.image = image
        super.init(tag: tag, subnodes: subnodes) { (imageView: T?) -> T in
            let imgView = initializer(imageView)
            imgView.image = image
            return imgView
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        let imageView = Thread.current.cachedObject(for: "ImageNode.imageView") {
            return UIImageView()
        }
        
        imageView.image = image
        return imageView.sizeThatFits(size)
    }
}
