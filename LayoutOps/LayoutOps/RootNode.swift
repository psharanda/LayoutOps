//
//  RootNode.swift
//  LayoutOps
//
//  Created by Pavel Sharanda on 02.05.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

public final class RootNode: Layoutable {
    
    public var bounds: CGRect {
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    public var frame = CGRect()
    
    public var lx_viewport: CGRect?
    
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize()
    }
    
    public weak var lx_parent: Layoutable? {
        return nil
    }
    
    private var subnodes: [NodeProtocol]
    
    private let layout: (RootNode)->Void
    
    public init(subnodes: [NodeProtocol] = [], layout: @escaping (RootNode)->Void) {
        self.subnodes = subnodes
        self.layout = layout
        
        subnodes.forEach {
            $0.lx_parent = self
        }
    }
    
    public convenience init(estimatedWidth: CGFloat) {
        self.init { rootNode in
            rootNode.frame.size.width = estimatedWidth
        }
    }
    
    public convenience init(estimatedHeight: CGFloat) {
        self.init { rootNode in
            rootNode.frame.size.height = estimatedHeight
        }
    }
    
    public convenience init(estimatedSize: CGSize) {
        self.init { rootNode in
            rootNode.frame.size = estimatedSize
        }
    }
    
    public func install(in container: NodeContainer) {
        if container.bounds.size != bounds.size {
            layout(for: container.bounds.size)
        }
        subnodes.forEach {
            $0.install(in: container)
        }
    }
    
    public func layout(for size: CGSize) {
        frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        layout(self)
    }
    
    public func prepareForReuse(in container: NodeContainer) {
        subnodes.forEach {
            $0.prepareForReuse(in: container)
        }
    }
}

extension RootNode: LayoutingCompatible { }
