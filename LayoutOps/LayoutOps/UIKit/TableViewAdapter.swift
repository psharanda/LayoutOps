//
//  Created by Pavel Sharanda on 25.04.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

public final class TableViewAdapter {
    private let nodeForIndexPath: (IndexPath, Bool)-> RootNode
    private var nodesCache = [IndexPath: RootNode]()
    
    public init(nodeForIndexPath: @escaping (IndexPath, Bool)-> RootNode) {
        self.nodeForIndexPath = nodeForIndexPath
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.frame.width < 1 {
            return 0
        }
        
        let node = nodeForIndexPath(indexPath, true)
        node.layout(for: CGSize(width: tableView.frame.width, height: 0))
        return node.frame.height + ((tableView.separatorStyle == .none) ? 0.0 : 0.5)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let node = nodeForIndexPath(indexPath, false)
        node.layout(for: CGSize(width: tableView.frame.width, height: 0))
        nodesCache[indexPath] = node
        return node.frame.height + ((tableView.separatorStyle == .none) ? 0.0 : 0.5)
    }
    
    public func tableView<T: NodeTableViewCell>(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, reuseIdentifier: String  = String(describing: T.self)) -> T {
        return (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T)  ?? T(reuseIdentifier: reuseIdentifier)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let c = cell as? NodeTableViewCell {
            c.rootNode = nodesCache[indexPath]
            nodesCache[indexPath] = nil
        } else {
            print("[WARNING:LayoutOps:installNode] \(cell) is not subclass of NodeTableViewCell")
        }
    }
}
