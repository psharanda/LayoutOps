//
//  Created by Pavel Sharanda on 23.10.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

#if os(iOS)
import UIKit

///Base adapter with agressive caching, though needs manual reset for cache
public class TableViewPresentationAdapter: BaseTableViewPresentationAdapter {
    
    private let resetCacheClosure: ()->Void
    
    public override init(presentationItemForHeader: @escaping (Int, Bool)-> PresentationTableHeaderFooterProtocol = { _, _ in PresentationTableHeaderFooter<NodeTableHeaderFooterView>(model: RootNode(height: 0)) },
                presentationItemForFooter: @escaping (Int, Bool)-> PresentationTableHeaderFooterProtocol = { _, _ in  PresentationTableHeaderFooter<NodeTableHeaderFooterView>(model: RootNode(height: 0)) },
                presentationItemForRow: @escaping (IndexPath, Bool)-> PresentationTableRowProtocol) {
        
        var headersCache: [Int: PresentationTableHeaderFooterProtocol] = [:]
        var footersCache: [Int: PresentationTableHeaderFooterProtocol] = [:]
        var rowsCache: [IndexPath: PresentationTableRowProtocol] = [:]
        
        resetCacheClosure = {
            headersCache.removeAll()
            footersCache.removeAll()
            rowsCache.removeAll()
        }
        
        super.init(presentationItemForHeader: { section, estimated in
            if estimated {
                return presentationItemForHeader(section, true)
            } else {
                if let item = headersCache[section] {
                    return item
                } else {
                    let item = presentationItemForHeader(section, false)
                    headersCache[section] = item
                    return item
                }
            }
        }, presentationItemForFooter: { section, estimated in
            if estimated {
                return presentationItemForFooter(section, true)
            } else {
                if let item = footersCache[section] {
                    return item
                } else {
                    let item = presentationItemForFooter(section, false)
                    footersCache[section] = item
                    return item
                }
            }
        }, presentationItemForRow:  { indexPath, estimated in
            if estimated {
                return presentationItemForRow(indexPath, true)
            } else {
                if let item = rowsCache[indexPath] {
                    return item
                } else {
                    let item = presentationItemForRow(indexPath, false)
                    rowsCache[indexPath] = item
                    return item
                }
            }
        })
    }
    
    ///call this before any reload*/insert*/delete*/move* tableview methods
    public func resetCache() {
        resetCacheClosure()
    }
}

#endif
