//
//  Created by Pavel Sharanda on 02.05.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

final class NodesSequenceDisplayAdapter<Index: Hashable> {
    
    private let itemNode: (Index, Bool)-> RootNode
    
    private var cache = [Index: RootNode]()
    
    
    init(itemNode: @escaping (Index, Bool)-> RootNode) {
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
        
        
        let didLayoutForWidth = (size.width > 0 && isAlmostEqual(left:  node.frame.width, right: size.width)) || isAlmostEqual(left: size.width, right: 0)
        let didLayoutForHeight = (size.height > 0 && isAlmostEqual(left:  node.frame.height, right: size.height)) || isAlmostEqual(left: size.height, right: 0)
        
        if !(didLayoutForWidth && didLayoutForHeight) {
            node.layout(for: size)
        }
        
        cache[index] = node
        return node.frame.size
    }
    
    func willDisplay(view: UIView, for index: Index) {
        if let v = view as? NodeItemView {
            v.rootNode = cache[index]
            cache[index] = nil
        }
    }
}
