//
//  UIView+Node.swift
//  LayoutOps
//
//  Created by Pavel Sharanda on 02.05.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation
import UIKit

private var key: UInt8 = 0

extension UIView: NodeContainer {
    
    public func lx_add(child: NodeContainer) {
        if let child = child as? UIView {
            addSubview(child)
        }
    }
    
    public var lx_tag: String? {
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
    }
    
    public func lx_child(with tag: String) -> NodeContainer? {
        for v in subviews {
            if v.lx_tag == Optional.some(tag) {
                return v
            }
        }
        return nil
    }
}

extension CALayer: NodeContainer {
    
    public func lx_add(child: NodeContainer) {
        if let child = child as? CALayer {
            addSublayer(child)
        }
    }
    
    public var lx_tag: String? {
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
    }
    
    public func lx_child(with tag: String) -> NodeContainer? {
        for v in sublayers ?? [] {
            if v.lx_tag == Optional.some(tag) {
                return v
            }
        }
        return nil
    }
}


