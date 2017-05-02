//
//  Created by Pavel Sharanda on 25.04.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import UIKit

open class NodeTableViewCell: UITableViewCell {

    public required init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        rootNode?.install(in: contentView)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        rootNode?.prepareForReuse(in: contentView)
    }
    
    public var rootNode: RootNode?
}



