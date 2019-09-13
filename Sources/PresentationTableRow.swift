//
//  Created by Pavel Sharanda on 27.08.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol PresentationTableRowProtocol: PresentationItemProtocol  {
    func makeView(_ tableView: UITableView) -> UITableViewCell
}

public class PresentationTableRow<ViewType: UITableViewCell>: PresentationItem<ViewType>, PresentationTableRowProtocol where ViewType: PresentationModelViewProtocol {
    
    public let reuseIdentifier: String
    
    #if swift(>=4.2)
    public let style: UITableViewCell.CellStyle
    public init(model: ViewType.PresentationModelType, reuseIdentifier: String = String(describing: ViewType.self), style: UITableViewCell.CellStyle = .default) {
        self.style = style
        self.reuseIdentifier = reuseIdentifier
        super.init(model: model)
    }
    #else
    public let style: UITableViewCellStyle
    public init(model: ViewType.PresentationModelType, reuseIdentifier: String = String(describing: ViewType.self), style: UITableViewCellStyle = .default) {
        self.style = style
        self.reuseIdentifier = reuseIdentifier
        super.init(model: model)
    }
    #endif
    
    public func makeView(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ViewType  ?? ViewType(style: style, reuseIdentifier: reuseIdentifier)
        configureView(cell)
        return cell
    }
}

#endif
