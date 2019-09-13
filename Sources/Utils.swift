//
//  Created by Pavel Sharanda on 10.02.2018.
//  Copyright © 2018 LayoutOps. All rights reserved.
//

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

struct ScreenCache {
    #if os(macOS)
    static let scale = NSScreen.main?.backingScaleFactor ?? 1
    #else
    static let scale = UIScreen.main.scale;
    #endif
}

extension CGFloat {
    
    var pixelPerfect: CGFloat {
        let scale = ScreenCache.scale
        return (self * scale).rounded()/scale;
    }
    
    var ceilPixelPerfect: CGFloat {
        let scale = ScreenCache.scale
        return ceil(self * scale)/scale;
    }
}

extension CGRect {
    //convert from cartesian <-> flipped coordinate space
    func flipped(in rect: CGRect?) -> CGRect {
        return CGRect(x: minX, y: (rect?.height ?? 0) - maxY, width: width, height: height)
    }
}
