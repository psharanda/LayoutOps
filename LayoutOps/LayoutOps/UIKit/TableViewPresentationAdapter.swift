//
//  Created by Pavel Sharanda on 25.04.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

public final class TableViewPresentationAdapter {
    
    private let headerNodeSequence: FooterHeaderSequenceDisplayAdapter
    private let footerNodeSequence: FooterHeaderSequenceDisplayAdapter
    private let cellNodeSequence: RowsSequenceDisplayAdapter
    
    
    public init(headerNodeForSection: @escaping (Int, Bool)-> TableHeaderFooterProtocol = { _, _ in TableHeaderFooter<NodeTableHeaderFooterView>(model: RootNode(height: 0)) },
                footerNodeForSection: @escaping (Int, Bool)-> TableHeaderFooterProtocol = { _, _ in  TableHeaderFooter<NodeTableHeaderFooterView>(model: RootNode(height: 0)) },
                cellNodeForIndexPath: @escaping (IndexPath, Bool)-> TableRowProtocol) {
        headerNodeSequence = FooterHeaderSequenceDisplayAdapter(itemNode: headerNodeForSection)
        footerNodeSequence = FooterHeaderSequenceDisplayAdapter(itemNode: footerNodeForSection)
        cellNodeSequence = RowsSequenceDisplayAdapter(itemNode: cellNodeForIndexPath)
    }
    
    //MARK: - cells
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellNodeSequence.makeView(tableView, for: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellNodeSequence.estimatedSize(for: indexPath, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let separatorHeight: CGFloat = ((tableView.separatorStyle == .none) ? 0.0 : 1.0/UIScreen.main.scale)
        return cellNodeSequence.size(for: indexPath, size: CGSize(width: tableView.bounds.size.width, height: 0)).height + separatorHeight
    }
    
    //MARK: - footers
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerNodeSequence.makeView(tableView, for: section)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let h = footerNodeSequence.estimatedSize(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
        if isAlmostEqual(left: h, right: 0) {
            return 2
        } else {
            return h
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let h = footerNodeSequence.size(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
        
        if isAlmostEqual(left: h, right: 0) {
            return CGFloat.leastNormalMagnitude
        } else {
            return h
        }
    }
    
    //MARK: - headers
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerNodeSequence.makeView(tableView, for: section)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let h = headerNodeSequence.estimatedSize(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
        if isAlmostEqual(left: h, right: 0) {
            return 2
        } else {
            return h
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let h = headerNodeSequence.size(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
        
        if isAlmostEqual(left: h, right: 0) {
            return CGFloat.leastNormalMagnitude
        } else {
            return h
        }
    }
}

class RowsSequenceDisplayAdapter {
    
    private let itemNode: (IndexPath, Bool)-> TableRowProtocol
    
    private var cache = [IndexPath: TableRowProtocol]()
    
    
    init(itemNode: @escaping (IndexPath, Bool)-> TableRowProtocol) {
        self.itemNode = itemNode
    }
    
    func estimatedSize(for index: IndexPath, size: CGSize) -> CGSize {
        if size.width < 1 && size.height < 1 {
            return CGSize()
        }
        
        let node = itemNode(index, true)
        return node.calculate(for: size)
    }
    
    func size(for index: IndexPath, size: CGSize) -> CGSize {
        return cache[index]?.calculate(for: size) ?? CGSize()
    }
    
    func makeView(_ tableView: UITableView, for index: IndexPath) -> UITableViewCell {
        let node = itemNode(index, false)
        cache[index] = node
        return node.makeView(tableView)
    }
}

class FooterHeaderSequenceDisplayAdapter {
    
    private let itemNode: (Int, Bool)-> TableHeaderFooterProtocol
    
    private var cache = [Int: TableHeaderFooterProtocol]()
    
    
    init(itemNode: @escaping (Int, Bool)-> TableHeaderFooterProtocol) {
        self.itemNode = itemNode
    }
    
    func estimatedSize(for index: Int, size: CGSize) -> CGSize {
        if size.width < 1 && size.height < 1 {
            return CGSize()
        }
        
        let node = itemNode(index, true)
        return node.calculate(for: size)
    }
    
    func size(for index: Int, size: CGSize) -> CGSize {
        let node = itemNode(index, false)
        cache[index] = node
        return node.calculate(for: size)
    }
    
    func makeView(_ tableView: UITableView, for index: Int) -> UIView {
        return cache[index]?.makeView(tableView) ?? UIView()
    }
}

