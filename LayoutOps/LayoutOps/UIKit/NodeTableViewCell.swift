//
//  Created by Pavel Sharanda on 25.04.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import UIKit

public protocol NodeItemView: class {
    var rootNode: RootNode? {get set}
}

open class NodeTableViewCell: UITableViewCell, NodeItemView {

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

open class NodeTableHeaderFooterView: UITableViewHeaderFooterView, NodeItemView {
    
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



