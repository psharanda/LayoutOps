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
        
        Combine(
            HPut(
                Fix(50),
                Fix(blueView, 120),
                Fix(greenView, 40),
                Fix(10),
                Fix(redView, 60)
            ),
            VPut(
                Fix(50),
                Fix(blueView, 120),
                Fix(greenView, 40),
                Fix(10),
                Fix(redView, 60)
            )
        ).layout()
    }
    
    static let title = "Fix"
    static let comments = "HPut and VPut operations successively layout views in superview in horizontal or vertical direction using intentions. Fix intention means that view size will take exact value, either directly defined or current one"
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
        
        Combine(
            HPut(
                Flex(blueView, 0.5),
                Flex(greenView, 1.0),
                Flex(redView, 0.5)
            ),
            VPut(
                Flex(),
                Flex(blueView),
                Flex(greenView),
                Flex(redView),
                Flex()
            )
        ).layout()
    }
    
    static let title = "Flex"
    static let comments = "HPut and VPut operations successively layout views in superview in horizontal or vertical direction using intentions. Flex intention means that view size will take value based weight of flex value. Flex operates only with free space left after Fix intentions"
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
        
        Combine(
            HPut(
                Fix(20),
                Fix(blueView, 100),
                Fix(20),
                Flex(greenView),
                Fix(20),
                Fix(redView, 100),
                Fix(20)
            ),
            VFill(blueView, inset: 40),
            VFill(greenView, inset: 40),
            VFill(redView, inset: 40)
        ).layout()
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
        
        Combine(
            HPut(
                Flex(),
                Fix(blueView, 70),
                Fix(10),
                Fix(greenView, 40),
                Fix(20),
                Fix(redView, 20),
                Flex()
            ),
            VFill(blueView, inset: 40),
            VFill(greenView, inset: 40),
            VFill(redView, inset: 40)
        ).layout()
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
        
        Combine(
            HPut(
                Flex(),
                Fix(blueView, 70),
                Fix(10),
                Fix(greenView, 40),
                Fix(20),
                Fix(redView, 20),
                Flex()
            ),
            VPut(
                Fix(40),
                Flex([blueView, greenView, redView]),
                Fix(40)
            )
        ).layout()
    }
    
    static let title = "Multi"
    static let comments = "Single intention can be defined for several views, all calculations are doing for first one, and others use its result as is"
    
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
        
        func putCols() -> LayoutOperation {
            var r = [PutIntention]()
            for i in 0..<8 {
                
                var row = [UIView]()
                for j in 0..<8 {
                    row.append(views[i*8 + j])
                }
                r.append(Flex(row))
            }
            return HPut(r)
        }
        
        func putRows() -> LayoutOperation {
            var r = [PutIntention]()
            
            for i in 0..<8 {
                
                var col = [UIView]()
                for j in 0..<8 {
                    col.append(views[i + j*8])
                }
               r.append(Flex(col))
            }
            return VPut(r)
        }
        
        Combine(
            putCols(),
            putRows()
        ).layout()
    }
    
    static let title = "Fix+Flex grid"
    static let comments = "Elegant way to layout views in grid using just one HPut and one VPut"
}