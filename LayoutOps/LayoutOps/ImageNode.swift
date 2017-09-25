//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public class ImageNode<T: UIImageView>: Node<T> {
    
    public let image: UIImage?
    
    public init(tag: TagConvertible, image: UIImage?, subnodes: [NodeProtocol] = [], prepareForReuse: @escaping ((T)->Void) = {_ in }, initializer: @escaping (T?)->T) {
        self.image = image
        super.init(tag: tag, subnodes: subnodes, prepareForReuse: prepareForReuse) { (imageView: T?) -> T in
            let imgView = initializer(imageView)
            imgView.image = image
            return imgView
        }
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return image?.size ?? .zero
    }
}
