### Basic
#### Set*
set* operations directly put frame values
```swift


blueView.lx.set(x: 10, y: 10)
    .set(width: 100, height: 100)

greenView.lx.set(x: 120, y: 20, width: 50, height: 190)

redView.lx.set(x: 5)
    .set(y: 120)
    .set(width: 45)
    .set(height: 100)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Basic_Set-_portrait.png" alt="Set*" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Basic__Set-_landscape.png" alt="Set*" width="240.0" height="160.0"/>
#### Center
hcenter (horizontally), vcenter (vertically) and center (both) operations allows to center view in superview. Insets can be used to adjust center point (see green view, 100 pt from bottom). Size of view usually should be set with previous operations
```swift



blueView.lx.set(y: 5)
    .set(width: 100, height: 100)
    .hcenter()

greenView.lx.set(x: 5)
    .set(width: 50, height: 120)
    .vcenter(topInset: 0, bottomInset: 100)

redView.lx.set(width: 45, height: 100)
    .center()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Basic_Center_portrait.png" alt="Center" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Basic__Center_landscape.png" alt="Center" width="240.0" height="160.0"/>
#### Fill
hfill (horizontally), vfill (vertically) and fill (both) operations make view to fill its superview. Insets can be used to control how much space to be left unfilled from the superview edges
```swift



redView.lx.fill(inset: 5)

blueView.lx.set(y: 20)
    .set(height: 50)
    .hfill(inset: 10)

greenView.lx.set(x: 25)
    .set(width: 50)
    .vfill(topInset: 100, bottomInset: 15)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Basic_Fill_portrait.png" alt="Fill" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Basic__Fill_landscape.png" alt="Fill" width="240.0" height="160.0"/>
#### Align
align* operations allow to put view relatively to edges of superview. Inset value can be used to set distance to edge. Size of view usually should be set with previous operations.
```swift



blueView.lx.set(width: 100, height: 100)
    .alignLeft(5)
    .alignTop(5)

greenView.lx.set(width: 50, height: 120)
    .alignLeft(10)
    .alignBottom(15)

redView.lx.set(width: 45, height: 100)
    .alignRight(25)
    .alignTop(25)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Basic_Align_portrait.png" alt="Align" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Basic__Align_landscape.png" alt="Align" width="240.0" height="160.0"/>
### SizeToFit
#### .value
sizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. .value option sets exact value for box. Result size will be equal or less than it.
```swift


icon.lx.sizeToFit(width: .value(100), height: .value(100))
    .alignTop(10)
    .hcenter()

label.lx.sizeToFit(width: .value(100), height: .value(100))
    .center()

title.lx.sizeToFit(width: .value(100), height: .value(100))
    .alignBottom(10)
    .hcenter()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/SizeToFit_.value_portrait.png" alt=".value" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/SizeToFit__.value_landscape.png" alt=".value" width="240.0" height="160.0"/>
#### .max
.max option sets infinite value for fitting box. Result size will be most comfortable for view to display content. WARNING: multiline labels are comfortable with single line, don't use .max for width
```swift


icon.lx.sizeToFitMax()  //same as view.lx.sizeToFit(width: .Max, height: .Max)
    .alignTop(10)
    .hcenter()

label.lx.sizeToFit(width: .max, height: .max)
    .center()

title.lx.sizeToFit(width: .max, height: .max)
    .alignBottom(10)
    .hcenter()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/SizeToFit_.max_portrait.png" alt=".max" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/SizeToFit__.max_landscape.png" alt=".max" width="240.0" height="160.0"/>
#### .current
.current option sets value for box with current frame's width or height.
```swift


icon.lx.set(size: CGSize(width: 200, height: 200))
    .sizeToFit(width: .current, height: .current)
    .alignTop(10)
    .hcenter()

label.lx.hfill(leftInset: 20, rightInset: 20)
    .sizeToFit() //same as view.lx.sizeToFit(width: .Current, height: .Current)
    .center()

title.lx.hfill(leftInset: 20, rightInset: 20)
    .sizeToFit(width: .current, height: .current)
    .alignBottom(10)
    .hcenter()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/SizeToFit_.current_portrait.png" alt=".current" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/SizeToFit__.current_landscape.png" alt=".current" width="240.0" height="160.0"/>
#### .keepCurrent
.keepCurrent options sets value for box with current frame's width or height, but result size will be still equal to those original frame values. This is usefull to layout multiline labels. First you need to set somehow label width, and then call something like label.lx.sizeToFit(width: .keepCurrent, height: .max).
```swift


icon.lx.set(size: CGSize(width: 200, height: 200))
    .sizeToFit(width: .keepCurrent, height: .max)
    .alignTop(10)
    .hcenter()

label.lx.hfill(leftInset: 20, rightInset: 20)
    .sizeToFit(width: .keepCurrent, height: .max)
    .center()

title.lx.hfill(leftInset: 20, rightInset: 20)
    .sizeToFit(width: .keepCurrent, height: .max)
    .alignBottom(10)
    .hcenter()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/SizeToFit_.keepCurrent_portrait.png" alt=".keepCurrent" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/SizeToFit__.keepCurrent_landscape.png" alt=".keepCurrent" width="240.0" height="160.0"/>
#### min/max constraints
sizeToFit operation also can have min, max or both constraints to limit resulted width/height. 
```swift


label.lx.sizeToFitMax(widthConstraint: .max(100), heightConstraint: .min(300))
    .center()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/SizeToFit_min-max constraints_portrait.png" alt="min/max constraints" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/SizeToFit__min-max constraints_landscape.png" alt="min/max constraints" width="240.0" height="160.0"/>
### Follow
#### Corners
Follow operation makes one view's anchor to be the same with others view anchor. Anchors can be horizontal and vertical, and can be followed only with anchors of the same type
```swift


blueView.lx.set(x: 10, y: 10)
    .set(width: 100, height: 100)

greenView.lx.set(width: 50, height: 190)
greenView.lx.leftAnchor.follow(blueView.lx.rightAnchor)
greenView.lx.topAnchor.follow(blueView.lx.bottomAnchor)

redView.lx.set(width: 30, height: 30)
redView.lx.leftAnchor.follow(blueView.lx.leftAnchor)
redView.lx.bottomAnchor.follow(greenView.lx.bottomAnchor)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Follow_Corners_portrait.png" alt="Corners" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Follow__Corners_landscape.png" alt="Corners" width="240.0" height="160.0"/>
#### Center
There are not only edge anchors, but also center anchors
```swift



blueView.lx.set(x: 10, y: 10)
    .set(width: 200)
    .vfill(inset: 20)

greenView.lx.set(width: 50, height: 190)
greenView.lx.leftAnchor.follow(blueView.lx.rightAnchor)
greenView.lx.vcenterAnchor.follow(blueView.lx.vcenterAnchor)

redView.lx.set(width: 30, height: 30)
redView.lx.hcenterAnchor.follow(greenView.lx.hcenterAnchor)
redView.lx.vcenterAnchor.follow(greenView.lx.vcenterAnchor)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Follow_Center_portrait.png" alt="Center" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Follow__Center_landscape.png" alt="Center" width="240.0" height="160.0"/>
#### Size
There are also size anchors
```swift


blueView.lx.set(x: 10)
    .set(width: 50)
    .vfill(inset: 100)

greenView.lx.heightAnchor.follow(blueView.lx.widthAnchor)
greenView.lx.widthAnchor.follow(blueView.lx.heightAnchor)
greenView.lx.leftAnchor.follow(blueView.lx.rightAnchor)
greenView.lx.topAnchor.follow(blueView.lx.bottomAnchor)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Follow_Size_portrait.png" alt="Size" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Follow__Size_landscape.png" alt="Size" width="240.0" height="160.0"/>
#### Baseline
firstBaselineAnchor/lastBaselineAnchor anchors are special. Only Baselinable views have it. For the moment only UILabel is conforming this protocol
```swift


label.lx.hfill(inset: 20)
    .sizeToFit(width: .keepCurrent, height: .max)
    .center()

blueView.lx.set(height: 30)
    .hfill(inset: 20)

greenView.lx.set(height: 30)
    .hfill(inset: 20)

blueView.lx.bottomAnchor.follow(label.lx.firstBaselineAnchor)
greenView.lx.topAnchor.follow(label.lx.lastBaselineAnchor)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Follow_Baseline_portrait.png" alt="Baseline" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Follow__Baseline_landscape.png" alt="Baseline" width="240.0" height="160.0"/>
### Put
#### Fix
hput and vput operations successively layout views in superview in horizontal or vertical direction using intentions. Fix intention means that view size will take exact value, either directly defined or current one
```swift



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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put_Fix_portrait.png" alt="Fix" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put__Fix_landscape.png" alt="Fix" width="240.0" height="160.0"/>
#### Flex
hput and vput operations successively layout views in superview in horizontal or vertical direction using intentions. Flex intention means that view size will take value based weight of flex value. Flex operates only with free space left after Fix intentions
```swift



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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put_Flex_portrait.png" alt="Flex" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put__Flex_landscape.png" alt="Flex" width="240.0" height="160.0"/>
#### Fix+Flex
Biggest power comes when we combine Fix and Flex intentions
```swift



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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put_Fix+Flex_portrait.png" alt="Fix+Flex" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put__Fix+Flex_landscape.png" alt="Fix+Flex" width="240.0" height="160.0"/>
#### Fix+Flex center many views
It is really to easy to center bunch of views all together
```swift



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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put_Fix+Flex center many views_portrait.png" alt="Fix+Flex center many views" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put__Fix+Flex center many views_landscape.png" alt="Fix+Flex center many views" width="240.0" height="160.0"/>
#### Multi
Single intention can be defined for several views, all calculations are doing for first one, and others use this result as is
```swift



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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put_Multi_portrait.png" alt="Multi" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put__Multi_landscape.png" alt="Multi" width="240.0" height="160.0"/>
#### Fix+Flex grid
Elegant way to layout views in grid using just one hput and one vput
```swift


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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put_Fix+Flex grid_portrait.png" alt="Fix+Flex grid" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put__Fix+Flex grid_landscape.png" alt="Fix+Flex grid" width="240.0" height="160.0"/>
#### Put labels
hfillvfit is used to fill width and size to fit height for both labels. vput is used to center group of labels
```swift



titleLabel.lx.hfillvfit(inset: 20)
detailsLabel.lx.hfillvfit(inset: 20)
self.lx.vput(
    Flex(),
    Fix(titleLabel),
    Fix(20),
    Fix(detailsLabel),
    Flex()
)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put_Put labels_portrait.png" alt="Put labels" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put__Put labels_landscape.png" alt="Put labels" width="240.0" height="160.0"/>
#### Digimax
AL Battle
```swift


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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put_Digimax_portrait.png" alt="Digimax" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put__Digimax_landscape.png" alt="Digimax" width="240.0" height="160.0"/>
#### Wrap
Derivative from put operation. Accepts only Fix. Modifies parent frame to wrap childs. Method to perform selfsizing.
```swift


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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put_Wrap_portrait.png" alt="Wrap" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Put__Wrap_landscape.png" alt="Wrap" width="240.0" height="160.0"/>
### Viewport
#### Demo
Viewport can be defined using anchors of any childview, or nil anchor if using superview edges
```swift



blueView.lx.hfill(inset: 20)

self.lx.vput(
    Fix(20),
    Fix(blueView, 20),
    Fix(20),
    Flex(greenView),
    Fix(20)
)

greenView.lx.alignLeft(20)
    .set(width: 20)

self.lx.inViewport(topAnchor: blueView.lx.bottomAnchor, leftAnchor: greenView.lx.rightAnchor) {
    redView.lx.fill(inset: 5)
}
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Viewport_Demo_portrait.png" alt="Demo" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/master/README/Viewport__Demo_landscape.png" alt="Demo" width="240.0" height="160.0"/>
