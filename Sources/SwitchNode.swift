//
//  Created by Pavel Sharanda on 23.11.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation
import UIKit

public class SwitchNode<T: UISwitch>: Node<T> {

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 51, height: 31)
    }
}
