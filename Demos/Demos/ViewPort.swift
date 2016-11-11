//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//


import UIKit
import LayoutOps

class ViewPortDemo: UIView, DemoViewProtocol {
    
    let blueView = makeBlueView()
    let greenView = makeGreenView()
    let redView = makeRedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(blueView)
        addSubview(greenView)
        addSubview(redView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Combine(
            HFill(blueView, inset: 20),
            VPut(
                Fix(20),
                Fix(blueView, 20),
                Fix(20),
                Flex(greenView),
                Fix(20)
            ),
            AlignLeft(greenView, inset: 20),
            SetWidth(greenView, value: 20),
            
            Combine(Viewport(topAnchor: BottomAnchor(blueView), leftAnchor: RightAnchor(greenView)), operations:
                Fill(redView, inset: 5)
            )
        ).layout()
    }
    
    static let title = "Demo"
    static let comments = "Combine operation not only allows to group other operations, but also define viewport for them. Viewport can be defined using anchors of childview, or nil anchor if using superview edges"
}