//
//  Created by Pavel Sharanda on 25.04.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

public final class TableViewNodesDisplayAdapter {
    
    private let headerNodeSequence: NodesSequenceDisplayAdapter<Int>
    private let footerNodeSequence: NodesSequenceDisplayAdapter<Int>
    private let cellNodeSequence: NodesSequenceDisplayAdapter<IndexPath>
    
    
    public init(headerNodeForSection: @escaping (Int, Bool)-> RootNode = { _, _ in RootNode(height: 0) },
                footerNodeForSection: @escaping (Int, Bool)-> RootNode = { _, _ in RootNode(height: 0) },
                cellNodeForIndexPath: @escaping (IndexPath, Bool)-> RootNode) {
        headerNodeSequence = NodesSequenceDisplayAdapter(itemNode: headerNodeForSection)
        footerNodeSequence = NodesSequenceDisplayAdapter(itemNode: footerNodeForSection)
        cellNodeSequence = NodesSequenceDisplayAdapter(itemNode: cellNodeForIndexPath)
    }
    
    
    //MARK: - cells
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellNodeSequence.estimatedSize(for: indexPath, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let separatorHeight: CGFloat = ((tableView.separatorStyle == .none) ? 0.0 : 1.0/UIScreen.main.scale)
        return cellNodeSequence.size(for: indexPath, size: CGSize(width: tableView.bounds.size.width, height: 0)).height + separatorHeight
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellNodeSequence.willDisplay(view: cell, for: indexPath)
    }
    
    //MARK: - footers
    
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
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        footerNodeSequence.willDisplay(view: view, for: section)
    }
    
    //MARK: - headers
    
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
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        headerNodeSequence.willDisplay(view: view, for: section)
    }
}

