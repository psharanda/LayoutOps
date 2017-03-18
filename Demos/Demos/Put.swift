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
    static let comments = "hput and vput operations successively layout views in superview in horizontal or vertical direction using intentions. Fix intention means that view size will take exact value, either directly defined or current one"
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
    static let comments = "hput and vput operations successively layout views in superview in horizontal or vertical direction using intentions. Flex intention means that view size will take value based weight of flex value. Flex operates only with free space left after Fix intentions"
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
    static let comments = "Single intention can be defined for several views, all calculations are doing for first one, and others use this result as is"
    
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
    static let comments = "hfillvfit is used to fill width and size to fit height for both labels. vput is used to center group of labels"
    
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
    static let comments = "Elegant way to layout views in grid using just one hput and one vput"
}

class PutDemo_DigiMax: UIView, DemoViewProtocol {
    
    let topView1 = makeViewWithColor(.red)
    let topView2 = makeViewWithColor(.blue)
    let topView3 = makeViewWithColor(.cyan)
    let cardView1 = makeViewWithColor(.green)
    let cardView2 = makeViewWithColor(.orange)
    let cardView3 = makeViewWithColor(.brown)
    let cardView4 = makeViewWithColor(.purple)
    
    let bottomView = makeViewWithColor(.gray)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(topView1)
        addSubview(topView2)
        addSubview(topView3)
        addSubview(cardView1)
        addSubview(cardView2)
        addSubview(cardView3)
        addSubview(cardView4)
        
        addSubview(bottomView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let topSize = CGSize(width: 60, height: 60)
        let topPadding: CGFloat = 10
        
        let topLeftRightPadding: CGFloat = 20
        
        topView1.lx.set(size: topSize)
            .alignTop(topPadding)
        topView2.lx.set(size: topSize)
            .alignTop(topPadding)
        topView3.lx.set(size: topSize)
            .alignTop(topPadding)
        
        lx.hput(
            Fix(topLeftRightPadding),
            Fix(topView1),
            Flex(),
            Fix(topView2),
            Flex(),
            Fix(topView3),
            Fix(topLeftRightPadding)
        )
        
        let cardSize = bounds.width < bounds.height ? CGSize(width: 80, height: 120) : CGSize(width: 60, height: 90)
        let cardLeftRightPadding: CGFloat = 25
        
        cardView1.lx.set(size: cardSize)
        cardView2.lx.set(size: cardSize)
        cardView3.lx.set(size: cardSize)
        cardView4.lx.set(size: cardSize)
        
        
        if bounds.width < bounds.height {
            cardView1.lx.vcenter()
            cardView2.lx.vcenter()
            
            lx.hput(
                Fix(cardLeftRightPadding),
                Fix(cardView1),
                Flex(),
                Fix(cardView2),
                Fix(cardLeftRightPadding)
            )
            
            cardView3.lx.hcenter()
            cardView4.lx.hcenter()
            
            lx.vput(
                Flex(),
                Fix(cardView3),
                Fix(60),
                Fix(cardView4),
                Flex()
            )
        } else {
            cardView1.lx.vcenter()
            cardView2.lx.vcenter()
            cardView3.lx.vcenter()
            cardView4.lx.vcenter()
            
            lx.hput(
                Fix(cardLeftRightPadding),
                Fix(cardView1),
                Flex(),
                Fix(cardView3),
                Flex(),
                Fix(cardView4),
                Flex(),
                Fix(cardView2),
                Fix(cardLeftRightPadding)
            )
        }
        
        
        bottomView.lx.set(height: 40)
            .hfill(inset: 100)
            .alignBottom(15)
    }
    
    static let title = "Digimax"
    static let comments = "AL Battle"
}

class PutDemo_Wrap: UIView, DemoViewProtocol {
    
    let container = makeGreenView()
    let title = makeTitleLabel()
    let details = makeDetailsLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(container)
        container.addSubview(title)
        container.addSubview(details)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxLabelsWidth: CGFloat = 250
        
        title.lx.sizeToFit(width: .value(maxLabelsWidth), height: .max)
        details.lx.sizeToFit(width: .value(maxLabelsWidth), height: .max)

        container.lx.hwrap(
            Fix(10),
            Fix([title, details], .max), //fixing for view with greatest width
            Fix(10)
        )
        
        container.lx.vwrap(
            Fix(10),
            Fix(title),
            Fix(10),
            Fix(details),
            Fix(10)
        )
        
        container.lx.center()
    }

    
    static let title = "Wrap"
    static let comments = "Derivative from put operation. Accepts only Fix. Modifies parent frame to wrap childs. Method to perform selfsizing."
}


