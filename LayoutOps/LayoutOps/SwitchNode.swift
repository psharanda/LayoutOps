//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

open class SwitchNode: AnyNode {
    
    
    public override init<T: UISwitch>(tag: Taggable, subnodes: [AnyNode] = [], initializer: @escaping (T?)->T) {
    
        super.init(tag: tag, subnodes: subnodes) { (switchView: T?) -> T in
            return initializer(switchView)
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        let switchView = Thread.current.cachedObject(for: "SwitchNode.switchView") {
            return UISwitch()
        }
        
        return switchView.sizeThatFits(size)
    }
}
