//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit


//MARK: - follow

private struct FollowOperation: LayoutOperation {
    
    let anchorToFollow: Anchor
    let followerAnchor: Anchor
    
    func calculateLayouts(inout layouts: ViewLayoutMap, viewport: Viewport) {
        
        let toFollowView = anchorToFollow.view
        let followerView = followerAnchor.view
        
        if(toFollowView.parent !== followerView.parent) {
            print("[LayoutOps:WARNING] Follow operation will produce undefined results for views with different superview")
            print("View to follow: \(toFollowView)")
            print("Follower view: \(followerView)")
        }
        
        let anchorToFollowFrame = frameForView(toFollowView, layouts: &layouts)
        let followerAnchorFrame = frameForView(followerView, layouts: &layouts)
        
        layouts[followerView] = followerAnchor.setValueForRect(anchorToFollow.valueForRect(anchorToFollowFrame), rect: followerAnchorFrame)
    }
    
    init(anchorToFollow: Anchor, followerAnchor: Anchor) {
        self.anchorToFollow = anchorToFollow
        self.followerAnchor = followerAnchor
    }
    
}

// anchor.value + inset = withAnchor.value + inset

public func Follow(anchor: HAnchor, withAnchor: HAnchor) -> LayoutOperation {
    return FollowOperation(anchorToFollow: anchor, followerAnchor: withAnchor)
}

public func Follow(anchor: VAnchor, withAnchor: VAnchor) -> LayoutOperation {
    return FollowOperation(anchorToFollow: anchor, followerAnchor: withAnchor)
}

public func Follow(anchor: SizeAnchor, withAnchor: SizeAnchor) -> LayoutOperation {
    return FollowOperation(anchorToFollow: anchor, followerAnchor: withAnchor)
}
