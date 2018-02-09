//
//  Created by Pavel Sharanda on 25.04.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation
import UIKit

open class NodeTableViewCell: UITableViewCell, PresentationModelViewProtocol {
    open override func layoutSubviews() {
        super.layoutSubviews()
        presentationModel?.install(in: contentView)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        presentationModel?.prepareForReuse(in: contentView)
    }
    public typealias PresentationModelType = RootNode
    open var presentationModel: RootNode?
}

public typealias NodeTableRow = PresentationTableRow<NodeTableViewCell>

open class NodeTableHeaderFooterView: UITableViewHeaderFooterView, PresentationModelViewProtocol {
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        presentationModel?.install(in: contentView)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        presentationModel?.prepareForReuse(in: contentView)
    }
    public typealias PresentationModelType = RootNode
    open var presentationModel: RootNode?
}

public typealias NodeTableHeaderFooter = PresentationTableHeaderFooter<NodeTableHeaderFooterView>

