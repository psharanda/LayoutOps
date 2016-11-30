//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

public class SwitchNode: AnyNode {
    
    
    public init<T: UISwitch>(tag: Taggable, image: UIImage?, subnodes: [AnyNode] = [], initializer: (T?)->T) {
    
        super.init(tag: tag, subnodes: subnodes) { (imageView: T?) -> T in
            return initializer(imageView)
        }
    }
    
    public override func sizeThatFits(size: CGSize) -> CGSize {
        
        struct Cache {
            static let switchView = UISwitch()
        }
        
        return Cache.switchView.sizeThatFits(size)
    }
}