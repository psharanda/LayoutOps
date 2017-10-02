//
//  Created by Pavel Sharanda on 25.04.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

public final class TableViewPresentationAdapter {
    
    private let headerSequenceDisplayAdapter: FooterHeaderSequencePresentationAdapter
    private let footerSequenceDisplayAdapter: FooterHeaderSequencePresentationAdapter
    private let rowsSequenceDisplayAdapter: RowsSequencePresentationAdapter
    
    
    public init(headerNodeForSection: @escaping (Int, Bool)-> PresentationTableHeaderFooterProtocol = { _, _ in PresentationTableHeaderFooter<NodeTableHeaderFooterView>(model: RootNode(height: 0)) },
                footerNodeForSection: @escaping (Int, Bool)-> PresentationTableHeaderFooterProtocol = { _, _ in  PresentationTableHeaderFooter<NodeTableHeaderFooterView>(model: RootNode(height: 0)) },
                cellNodeForIndexPath: @escaping (IndexPath, Bool)-> PresentationTableRowProtocol) {
        headerSequenceDisplayAdapter = FooterHeaderSequencePresentationAdapter(itemNode: headerNodeForSection)
        footerSequenceDisplayAdapter = FooterHeaderSequencePresentationAdapter(itemNode: footerNodeForSection)
        rowsSequenceDisplayAdapter = RowsSequencePresentationAdapter(itemNode: cellNodeForIndexPath)
    }
    
    //call this before any reload*/insert*/delete*/move* tableview methods
    public func resetCache() {
        headerSequenceDisplayAdapter.resetCache()
        footerSequenceDisplayAdapter.resetCache()
        rowsSequenceDisplayAdapter.resetCache()
    }
    
    //MARK: - cells
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return rowsSequenceDisplayAdapter.makeView(tableView, for: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowsSequenceDisplayAdapter.estimatedSize(for: indexPath, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let separatorHeight: CGFloat = ((tableView.separatorStyle == .none) ? 0.0 : 1.0/UIScreen.main.scale)
        return rowsSequenceDisplayAdapter.size(for: indexPath, size: CGSize(width: tableView.bounds.size.width, height: 0)).height + separatorHeight
    }
    
    //MARK: - footers
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerSequenceDisplayAdapter.makeView(tableView, for: section)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let h = footerSequenceDisplayAdapter.estimatedSize(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
        if isAlmostEqual(left: h, right: 0) {
            return 2
        } else {
            return h
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let h = footerSequenceDisplayAdapter.size(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
        
        if isAlmostEqual(left: h, right: 0) {
            return CGFloat.leastNormalMagnitude
        } else {
            return h
        }
    }
    
    //MARK: - headers
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerSequenceDisplayAdapter.makeView(tableView, for: section)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let h = headerSequenceDisplayAdapter.estimatedSize(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
        if isAlmostEqual(left: h, right: 0) {
            return 2
        } else {
            return h
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let h = headerSequenceDisplayAdapter.size(for: section, size: CGSize(width: tableView.bounds.size.width, height: 0)).height
        
        if isAlmostEqual(left: h, right: 0) {
            return CGFloat.leastNormalMagnitude
        } else {
            return h
        }
    }
}

class RowsSequencePresentationAdapter {
    
    private let itemNode: (IndexPath, Bool)-> PresentationTableRowProtocol
    
    private var cache = [IndexPath: PresentationTableRowProtocol]()
    
    
    init(itemNode: @escaping (IndexPath, Bool)-> PresentationTableRowProtocol) {
        self.itemNode = itemNode
    }
    
    func estimatedSize(for index: IndexPath, size: CGSize) -> CGSize {
        if size.width < 1 && size.height < 1 {
            return CGSize()
        }
        
        let node = itemNode(index, true)
        return node.calculate(for: size)
    }
    
    private func node(for index: IndexPath) -> PresentationTableRowProtocol {
        if let node = cache[index] {
            return node
        }
        
        let node = itemNode(index, false)
        cache[index] = node
        return node
    }
    
    func size(for index: IndexPath, size: CGSize) -> CGSize {
        return node(for: index).calculate(for: size)
    }
    
    func makeView(_ tableView: UITableView, for index: IndexPath) -> UITableViewCell {
        return node(for: index).makeView(tableView)
    }
    
    func resetCache() {
        cache.removeAll()
    }
}

class FooterHeaderSequencePresentationAdapter {
    
    private let itemNode: (Int, Bool)-> PresentationTableHeaderFooterProtocol
    
    private var cache = [Int: PresentationTableHeaderFooterProtocol]()
    
    
    init(itemNode: @escaping (Int, Bool)-> PresentationTableHeaderFooterProtocol) {
        self.itemNode = itemNode
    }
    
    func estimatedSize(for index: Int, size: CGSize) -> CGSize {
        if size.width < 1 && size.height < 1 {
            return CGSize()
        }
        
        let node = itemNode(index, true)
        return node.calculate(for: size)
    }
    
    private func node(for index: Int) -> PresentationTableHeaderFooterProtocol {
        if let node = cache[index] {
            return node
        }
        
        let node = itemNode(index, false)
        cache[index] = node
        return node
    }
    
    func size(for index: Int, size: CGSize) -> CGSize {
         return node(for: index).calculate(for: size)
    }
    
    func makeView(_ tableView: UITableView, for index: Int) -> UIView {
        return node(for: index).makeView(tableView)
    }
    
    func resetCache() {
        cache.removeAll()
    }
}

