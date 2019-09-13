//
//  Created by Pavel Sharanda on 27.08.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol PresentationTableHeaderFooterProtocol: PresentationItemProtocol  {
    func makeView(_ tableView: UITableView) -> UITableViewHeaderFooterView
}

public class PresentationTableHeaderFooter<ViewType: UITableViewHeaderFooterView>: PresentationItem<ViewType>, PresentationTableHeaderFooterProtocol where ViewType: PresentationModelViewProtocol {
    
    public let reuseIdentifier: String
    
    public init(model: ViewType.PresentationModelType, reuseIdentifier: String = String(describing: ViewType.self)) {
        self.reuseIdentifier = reuseIdentifier
        super.init(model: model)
    }
    
    public func makeView(_ tableView: UITableView) -> UITableViewHeaderFooterView {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? ViewType  ?? ViewType(reuseIdentifier: reuseIdentifier)
        configureView(view)
        return view
    }
}

#endif
