//
//  Utils.swift
//  LayoutOps
//
//  Created by Pavel Sharanda on 24.02.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import Foundation

extension Thread {
    func cachedObject<T: AnyObject>(for key: String, create: () -> T) -> T {
        if let cachedObject = threadDictionary[key] as? T {
            return cachedObject
        } else {
            let newObject = create()
            threadDictionary[key] = newObject
            return newObject
        }
    }
}

func isAlmostEqual(left: CGFloat, right: CGFloat) -> Bool
{
    return fabs(left.distance(to: right)) <= 1e-3
}

func isAlmostEqual(left: CGSize, right: CGSize) -> Bool
{
    return isAlmostEqual(left: left.width, right: right.width) && isAlmostEqual(left: left.height, right: right.height)
}
