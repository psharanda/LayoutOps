//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//


import UIKit
import LayoutOps


class DemoViewController: UIViewController {
    
    let demoView: UIView
    
    let descBackground = UIView()
    let descLabel = UILabel()
    
    init(title: String, description: String, demoView: UIView) {
        self.demoView = demoView
        super.init(nibName: nil, bundle: nil)
        self.title = title
        
        descLabel.text = description
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = UIColor(red: 0xF5/255.0, green: 0xF5/255.0, blue: 0xFA/255.0, alpha: 1)
        view.addSubview(demoView)
        
        demoView.backgroundColor = UIColor.whiteColor()
        demoView.layer.borderColor = UIColor(red: 0xE8/255.0, green: 0xE8/255.0, blue: 0xF3/255.0, alpha: 1).CGColor
        demoView.layer.borderWidth = 1
        
        descBackground.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        view.addSubview(descBackground)
        
        descLabel.textColor = UIColor.whiteColor()
        descLabel.textAlignment = .Center
        descLabel.numberOfLines = 0
        descLabel.font = UIFont.systemFontOfSize(12)
        view.addSubview(descLabel)
    }
    
    var topLayoutGuideLength: CGFloat?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // topLayoutGuide.length works unreliable most of times, let's just get bottom y of navbar instead
        let nc = navigationController?.navigationBar
        let realTopLayoutGuideLength = nc.map { $0.convertRect($0.bounds, toView: view).maxY } ?? 0
        
        
            
            descLabel.lx.hfillvfit(inset: 10)
            descLabel.lx.alignBottom(10)
            
            descBackground.lx.hfill()
            descBackground.lx.topAnchor.follow(descLabel.lx.topAnchor.insettedBy(-10))
            descBackground.lx.heightAnchor.follow(descLabel.lx.heightAnchor.insettedBy(20))
        
        
        view.lx.inViewport(bottomAnchor: descBackground.lx.topAnchor) {
            demoView.lx.fill(insets: UIEdgeInsetsMake(realTopLayoutGuideLength + 20, 20, 20, 20))
        }
        
    }
}
