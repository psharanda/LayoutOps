//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

private func follow_helper(_ anchorToFollow: Anchor, followerAnchor: Anchor) {
    let toFollowView = anchorToFollow.view
    let followerView = followerAnchor.view
    
    let followerAnchorFrame = followerView.frame
    
    var isParent = false
    if let parent = followerView.lx_parent, parent === toFollowView {
        isParent = true
    } else {
        if(toFollowView.lx_parent == nil) {
            print("[WARNING:LayoutOps:follow] nil parent \(toFollowView)")
        } else if(followerView.lx_parent == nil) {
            print("[WARNING:LayoutOps:follow] nil parent \(followerView)")
        } else if(toFollowView.lx_parent !== followerView.lx_parent) {
            print("[WARNING:LayoutOps:follow] different parents for \(toFollowView) and \(followerView)")
        }
    }
    
    let anchorToFollowFrame = isParent ? toFollowView.boundsOrViewPort : toFollowView.frame
    let result = followerAnchor.setValueForRect(anchorToFollow.valueForRect(anchorToFollowFrame), rect: followerAnchorFrame)    
    followerView.updateFrame(result)
}

extension VAnchor {
    public func follow(_ anchor: VAnchor) {
        follow_helper(anchor, followerAnchor: self)
    }
}

extension HAnchor {
    public func follow(_ anchor: HAnchor) {
        follow_helper(anchor, followerAnchor: self)
    }
}

extension SizeAnchor {
    public func follow(_ anchor: SizeAnchor) {
        follow_helper(anchor, followerAnchor: self)
    }
}
