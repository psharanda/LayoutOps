//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

#if os(iOS)
import UIKit

public class SwitchNode<T: UISwitch>: Node<T> {

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 51, height: 31)
    }
}

#endif
