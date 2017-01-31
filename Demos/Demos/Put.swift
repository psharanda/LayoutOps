//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//


import UIKit
import LayoutOps

class PutDemo_Fix: UIView, DemoViewProtocol {
    
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
        
        
        self.lx.hput(
            Fix(50),
            Fix(blueView, 120),
            Fix(greenView, 40),
            Fix(10),
            Fix(redView, 60)
        )
        self.lx.vput(
            Fix(50),
            Fix(blueView, 120),
            Fix(greenView, 40),
            Fix(10),
            Fix(redView, 60)
        )
        
    }
    
    static let title = "Fix"
    static let comments = "view_to_replace.lx.hput and view_to_replace.lx.vput operations successively layout views in superview in horizontal or vertical direction using intentions. Fix intention means that view size will take exact value, either directly defined or current one"
}

class PutDemo_Flex: UIView, DemoViewProtocol {
    
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
        
        
        self.lx.hput(
            Flex(blueView, 0.5),
            Flex(greenView, 1.0),
            Flex(redView, 0.5)
        )
        self.lx.vput(
            Flex(),
            Flex(blueView),
            Flex(greenView),
            Flex(redView),
            Flex()
        )
        
    }
    
    static let title = "Flex"
    static let comments = "view_to_replace.lx.hput and view_to_replace.lx.vput operations successively layout views in superview in horizontal or vertical direction using intentions. Flex intention means that view size will take value based weight of flex value. Flex operates only with free space left after Fix intentions"
}

class PutDemo_FixFlex: UIView, DemoViewProtocol {
    
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
        
        
        self.lx.hput(
            Fix(20),
            Fix(blueView, 100),
            Fix(20),
            Flex(greenView),
            Fix(20),
            Fix(redView, 100),
            Fix(20)
        )
        blueView.lx.vfill(inset: 40)
        greenView.lx.vfill(inset: 40)
        redView.lx.vfill(inset: 40)
        
    }
    
    static let title = "Fix+Flex"
    static let comments = "Biggest power comes when we combine Fix and Flex intentions"
}

class PutDemo_FixFlexCenter: UIView, DemoViewProtocol {
    
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
        
        
        self.lx.hput(
            Flex(),
            Fix(blueView, 70),
            Fix(10),
            Fix(greenView, 40),
            Fix(20),
            Fix(redView, 20),
            Flex()
        )
        blueView.lx.vfill(inset: 40)
        greenView.lx.vfill(inset: 40)
        redView.lx.vfill(inset: 40)
        
    }
    
    static let title = "Fix+Flex center many views"
    static let comments = "It is really to easy to center bunch of views all together"
}



class PutDemo_Multi: UIView, DemoViewProtocol {
    
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
        
        
        self.lx.hput(
            Flex(),
            Fix(blueView, 70),
            Fix(10),
            Fix(greenView, 40),
            Fix(20),
            Fix(redView, 20),
            Flex()
        )
        self.lx.vput(
            Fix(40),
            Flex([blueView, greenView, redView]),
            Fix(40)
        )
        
    }
    
    static let title = "Multi"
    static let comments = "Single intention can be defined for several views, all calculations are doing for first one, and others use its result as is"
    
}

class PutDemo_Labels: UIView, DemoViewProtocol {
    
    let titleLabel = makeTitleLabel()
    let detailsLabel = makeDetailsLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(detailsLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        titleLabel.lx.hfillvfit(inset: 20)
        detailsLabel.lx.hfillvfit(inset: 20)
        self.lx.vput(
            Flex(),
            Fix(titleLabel),
            Fix(20),
            Fix(detailsLabel),
            Flex()
        )
        
    }
    
    static let title = "Put labels"
    static let comments = "HFillVFit is used to fill width and size to fit height for both labels. view_to_replace.lx.vput is used to center group of labels"
    
}

class PutDemo_FixFlexGrid: UIView, DemoViewProtocol {
    
    var views: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for i in 0..<32 {
            if (i / 4) % 2 == 0 {
                views.append(makeGreenView())
                views.append(makeRedView())
            } else {
                views.append(makeRedView())
                views.append(makeGreenView())
            }
        }
        
        views.forEach {
            addSubview($0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        func putCols() {
            var r = [PutIntention]()
            for i in 0..<8 {
                
                var row = [Layoutable]()
                for j in 0..<8 {
                    row.append(views[i*8 + j])
                }
                r.append(Flex(row))
            }
            self.lx.hput(r)
        }
        
        func putRows() {
            var r = [PutIntention]()
            
            for i in 0..<8 {
                
                var col = [Layoutable]()
                for j in 0..<8 {
                    col.append(views[i + j*8])
                }
                r.append(Flex(col))
            }
            self.lx.vput(r)
        }
        
        
        putCols()
        putRows()
        
    }
    
    static let title = "Fix+Flex grid"
    static let comments = "Elegant way to layout views in grid using just one view_to_replace.lx.hput and one view_to_replace.lx.vput"
}