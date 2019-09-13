//
//  Created by Pavel Sharanda on 02.05.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

#if os(iOS)
import UIKit

public final class RootNode: Layoutable {
    
    //MARK: - confirm layoutable
    
    public var lx_frame: CGRect {
        get {
            return frame
        }
        set {
            frame = newValue
        }
    }
    
    public var lx_viewport: CGRect?
    
    public weak var lx_parent: Layoutable? {
        return nil
    }
    
    //MARK: -
    public var bounds: CGRect {
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    public var frame = CGRect()
    
    public var subnodes: [NodeProtocol]
    
    private let layout: (RootNode)->Void
    
    public init(subnodes: [NodeProtocol] = [], layout: @escaping (RootNode)->Void) {
        self.subnodes = subnodes
        self.layout = layout
        
        subnodes.forEach {
            $0.lx_parent = self
        }
    }
    
    public convenience init(width: CGFloat) {
        self.init { rootNode in
            rootNode.frame.size.width = width
        }
    }
    
    public convenience init(height: CGFloat) {
        self.init { rootNode in
            rootNode.frame.size.height = height
        }
    }
    
    public convenience init(size: CGSize) {
        self.init { rootNode in
            rootNode.frame.size = size
        }
    }
    
    public func install(in container: NodeContainer) {
        if !isAlmostEqual(left: container.lx_bounds.size, right: lx_bounds.size) {
            _ = calculate(for: container.lx_bounds.size)
        }
        subnodes.forEach {
            $0.install(in: container)
        }
    }
    
    public func calculate(for size: CGSize) -> CGSize {
        let didLayoutForWidth = (size.width > 0 && isAlmostEqual(left: frame.size.width, right: size.width)) || isAlmostEqual(left: size.width, right: 0)
        let didLayoutForHeight = (size.height > 0 && isAlmostEqual(left: frame.size.height, right: size.height)) || isAlmostEqual(left: size.height, right: 0)
        
        if !(didLayoutForWidth && didLayoutForHeight) {
            frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            layout(self)
        }
    
        return frame.size
    }
    
    public func prepareForReuse(in container: NodeContainer) {
        subnodes.forEach {
            $0.prepareForReuse(in: container)
        }
    }
}

extension RootNode: LayoutingCompatible { }

func isAlmostEqual(left: CGFloat, right: CGFloat) -> Bool
{
    #if swift(>=4.2)
        return abs(left.distance(to: right)) <= 1e-3
    #else
        return fabs(left.distance(to: right)) <= 1e-3
    #endif
    
}

func isAlmostEqual(left: CGSize, right: CGSize) -> Bool
{
    return isAlmostEqual(left: left.width, right: right.width) && isAlmostEqual(left: left.height, right: right.height)
}

#endif
