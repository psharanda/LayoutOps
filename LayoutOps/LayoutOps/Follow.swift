//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import UIKit

private func follow_helper(anchorToFollow: Anchor, followerAnchor: Anchor) {
    let toFollowView = anchorToFollow.view
    let followerView = followerAnchor.view
    
    if(toFollowView.parent !== followerView.parent) {
        print("[LayoutOps:WARNING] Follow operation will produce undefined results for views with different superview")
        print("View to follow: \(toFollowView)")
        print("Follower view: \(followerView)")
    }
    
    let anchorToFollowFrame = toFollowView.frame
    let followerAnchorFrame = followerView.frame
    
    let result = followerAnchor.setValueForRect(anchorToFollow.valueForRect(anchorToFollowFrame), rect: followerAnchorFrame)
    
    followerView.updateFrame(result)
}

extension VAnchor {
    public func follow(anchor: VAnchor) {
        follow_helper(anchor, followerAnchor: self)
    }
}

extension HAnchor {
    public func follow(anchor: HAnchor) {
        follow_helper(anchor, followerAnchor: self)
    }
}

extension SizeAnchor {
    public func follow(anchor: SizeAnchor) {
        follow_helper(anchor, followerAnchor: self)
    }
}