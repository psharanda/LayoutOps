//
//  Created by Pavel Sharanda on 25.04.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

public final class TableViewDisplayAdapter {
    
    private let headerNodeSequence: NodeSequenceDisplayAdapter<Int>
    private let footerNodeSequence: NodeSequenceDisplayAdapter<Int>
    private let cellNodeSequence: NodeSequenceDisplayAdapter<IndexPath>
    
    
    public init(headerNodeForSection: @escaping (Int, Bool)-> RootNode = { _, _ in RootNode(estimatedHeight: 0) },
                footerNodeForSection: @escaping (Int, Bool)-> RootNode = { _, _ in RootNode(estimatedHeight: 0) },
                cellNodeForIndexPath: @escaping (IndexPath, Bool)-> RootNode) {
        headerNodeSequence = NodeSequenceDisplayAdapter(itemNode: headerNodeForSection)
        footerNodeSequence = NodeSequenceDisplayAdapter(itemNode: footerNodeForSection)
        cellNodeSequence = NodeSequenceDisplayAdapter(itemNode: cellNodeForIndexPath)
    }
    
    //MARK: - cells

    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellNodeSequence.estimatedSize(for: indexPath, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellNodeSequence.size(for: indexPath, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellNodeSequence.willDisplay(view: cell, for: indexPath)
    }
    
    //MARK: - footers
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return footerNodeSequence.estimatedSize(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerNodeSequence.size(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        footerNodeSequence.willDisplay(view: view, for: section)
    }
    
    //MARK: - headers
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return headerNodeSequence.estimatedSize(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerNodeSequence.size(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        headerNodeSequence.willDisplay(view: view, for: section)
    }
}

public final class NodeSequenceDisplayAdapter<Index: Hashable> {
    
    private let itemNode: (Index, Bool)-> RootNode
    
    private var cache = [Index: RootNode]()
    
    public init(itemNode: @escaping (Index, Bool)-> RootNode) {
        self.itemNode = itemNode
    }
    
    func estimatedSize(for index: Index, size: CGSize) -> CGSize {
        if size.width < 1 && size.height < 1 {
            return CGSize()
        }
        
        let node = itemNode(index, true)
        node.layout(for: size)
        return node.frame.size
    }
    
    func size(for index: Index, size: CGSize) -> CGSize {
        let node = itemNode(index, false)
        node.layout(for: size)
        cache[index] = node
        return node.frame.size
    }
    
    func willDisplay(view: UIView, for index: Index) {
        if let v = view as? NodeItemView {
            v.rootNode = cache[index]
            cache[index] = nil
        } else {
            print("[WARNING:LayoutOps:willDisplay] \(view) is not conforming of NodeItemView")
        }
    }
}
