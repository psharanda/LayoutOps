//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public class ImageNode: Node {
    
    private let image: UIImage
    public init<T: UIImageView>(tag: Taggable, image: UIImage, subnodes: [Node] = [], initializer: (T?)->T) {
        self.image = image
        super.init(tag: tag, subnodes: subnodes) { (imageView: T?) -> T in
            let imgView = initializer(imageView)
            imgView.image = image
            return imgView
        }
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return image.size
    }
}