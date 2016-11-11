//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//


import UIKit
import LayoutOps

class PutDemo_Fix: UIView {
    
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
}

class PutDemo_Flex: UIView {
    
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
}

class PutDemo_FixFlex: UIView {
    
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
}

class PutDemo_FixFlexCenter: UIView {
    
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
}



class PutDemo_Multi: UIView {
    
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
}

class PutDemo_FixFlexGrid: UIView {
    
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
}