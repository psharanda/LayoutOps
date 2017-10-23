//
//  Created by Pavel Sharanda on 25.04.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation


///Base adapter without cache
open class BaseTableViewPresentationAdapter {
    
    private let headerSequenceDisplayAdapter: HeaderFooterSequencePresentationAdapter
    private let footerSequenceDisplayAdapter: HeaderFooterSequencePresentationAdapter
    private let rowsSequenceDisplayAdapter: RowsSequencePresentationAdapter
    
    
    public init(presentationItemForHeader: @escaping (Int, Bool)-> PresentationTableHeaderFooterProtocol = { _, _ in PresentationTableHeaderFooter<NodeTableHeaderFooterView>(model: RootNode(height: 0)) },
                presentationItemForFooter: @escaping (Int, Bool)-> PresentationTableHeaderFooterProtocol = { _, _ in  PresentationTableHeaderFooter<NodeTableHeaderFooterView>(model: RootNode(height: 0)) },
                presentationItemForRow: @escaping (IndexPath, Bool)-> PresentationTableRowProtocol) {
        headerSequenceDisplayAdapter = HeaderFooterSequencePresentationAdapter(presentationItemForHeaderFooter: presentationItemForHeader)
        footerSequenceDisplayAdapter = HeaderFooterSequencePresentationAdapter(presentationItemForHeaderFooter: presentationItemForFooter)
        rowsSequenceDisplayAdapter = RowsSequencePresentationAdapter(presentationItemForRow: presentationItemForRow)
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
    
    private let presentationItemForRow: (IndexPath, Bool)-> PresentationTableRowProtocol
    
    init(presentationItemForRow: @escaping (IndexPath, Bool)-> PresentationTableRowProtocol) {
        self.presentationItemForRow = presentationItemForRow
    }
    
    func estimatedSize(for index: IndexPath, size: CGSize) -> CGSize {
        if size.width < 1 && size.height < 1 {
            return CGSize()
        }
        return presentationItemForRow(index, true).calculate(for: size)
    }
    
    func size(for index: IndexPath, size: CGSize) -> CGSize {
        return presentationItemForRow(index, false).calculate(for: size)
    }
    
    func makeView(_ tableView: UITableView, for index: IndexPath) -> UITableViewCell {
        return presentationItemForRow(index, false).makeView(tableView)
    }
}

class HeaderFooterSequencePresentationAdapter {
    
    private let presentationItemForHeaderFooter: (Int, Bool)-> PresentationTableHeaderFooterProtocol
    
    init(presentationItemForHeaderFooter: @escaping (Int, Bool)-> PresentationTableHeaderFooterProtocol) {
        self.presentationItemForHeaderFooter = presentationItemForHeaderFooter
    }
    
    func estimatedSize(for index: Int, size: CGSize) -> CGSize {
        if size.width < 1 && size.height < 1 {
            return CGSize()
        }
        
        let node = presentationItemForHeaderFooter(index, true)
        return node.calculate(for: size)
    }
    
    func size(for index: Int, size: CGSize) -> CGSize {
         return presentationItemForHeaderFooter(index, false).calculate(for: size)
    }
    
    func makeView(_ tableView: UITableView, for index: Int) -> UIView {
        return presentationItemForHeaderFooter(index, false).makeView(tableView)
    }
}

