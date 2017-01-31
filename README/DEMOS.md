### Basic
#### Set*
Set* operations directly put frame values
```swift


blueView.lx
    .set(x: 10, y: 10)
    .set(width: 100, height: 100)

greenView.lx
    .set(x: 120, y: 20, width: 50, height: 190)

redView.lx
    .set(x: 5)
    .set(y: 120)
    .set(width: 45)
    .set(height: 100)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Set-_portrait.png" alt="Set*" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Set-_landscape.png" alt="Set*" width="240.0" height="160.0"/>
#### Center
HCenter (horizontally), VCenter (vertically) and Center (both) operations allows to center view in superview. Insets can be used to adjust center point (see green view, 100 pt from bottom). Size of view usually should be set with previous operations
```swift



blueView.lx
    .set(y: 5)
    .set(width: 100, height: 100)
    .hcenter()

greenView
    .lx.set(x: 5)
    .set(width: 50, height: 120)
    .vcenter(topInset: 0, bottomInset: 100)

redView.lx
    .set(width: 45, height: 100)
    .center()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Center_portrait.png" alt="Center" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Center_landscape.png" alt="Center" width="240.0" height="160.0"/>
#### Fill
HFill (horizontally), VFill (vertically) and Fill (both) operations make view to fill its superview. Insets can be used to control how much space to be left unfilled from the superview edges
```swift



redView.lx.fill(inset: 5)

blueView.lx
    .set(y: 20)
    .set(height: 50)
    .hfill(inset: 10)

greenView.lx
    .set(x: 25)
    .set(width: 50)
    .vfill(topInset: 100, bottomInset: 15)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Fill_portrait.png" alt="Fill" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Fill_landscape.png" alt="Fill" width="240.0" height="160.0"/>
#### Align
Align* operations allow to put view relatively to edges of superview. Inset value can be used to set distance to edge. Size of view usually should be set with previous operations.
```swift



blueView.lx
    .set(width: 100, height: 100)
    .alignLeft(5)
    .alignTop(5)

greenView.lx
    .set(width: 50, height: 120)
    .alignLeft(10)
    .alignBottom(15)

redView.lx
    .set(width: 45, height: 100)
    .alignRight(25)
    .alignTop(25)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Align_portrait.png" alt="Align" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Align_landscape.png" alt="Align" width="240.0" height="160.0"/>
### SizeToFit
#### .Value
SizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. .Value option sets exact value for box. Result size will be equal or less than it.
```swift


icon.lx
    .sizeToFit(width: .Value(100), height: .Value(100))
    .alignTop(10)
    .hcenter()

label.lx
    .sizeToFit(width: .Value(100), height: .Value(100))
    .center()

title.lx.sizeToFit(width: .Value(100), height: .Value(100))
    .alignBottom(10)
    .hcenter()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.Value_portrait.png" alt=".Value" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.Value_landscape.png" alt=".Value" width="240.0" height="160.0"/>
#### .Max
.Max option sets infinite value for fitting box. Result size will be most comfortable for view to display content. WARNING: multiline labels are comfortable with single line, don't use .Max for them
```swift


icon.lx.sizeToFitMax()  //same as view.lx.sizeToFit(width: .Max, height: .Max)
    .alignTop(10)
    .hcenter()

label.lx.sizeToFit(width: .Max, height: .Max)
    .center()

title.lx.sizeToFit(width: .Max, height: .Max)
    .alignBottom(10)
    .hcenter()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.Max_portrait.png" alt=".Max" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.Max_landscape.png" alt=".Max" width="240.0" height="160.0"/>
#### .Current
.Current option sets value for box with current frame's width or height.
```swift


icon.lx.set(size: CGSize(width: 200, height: 200))
    .sizeToFit(width: .Current, height: .Current)
    .alignTop(10)
    .hcenter()

label.lx.hfill(leftInset: 20, rightInset: 20)
    .sizeToFit() //same as view.lx.sizeToFit(width: .Current, height: .Current)
    .center()

title.lx.hfill(leftInset: 20, rightInset: 20)
    .sizeToFit(width: .Current, height: .Current)
    .alignBottom(10)
    .hcenter()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.Current_portrait.png" alt=".Current" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.Current_landscape.png" alt=".Current" width="240.0" height="160.0"/>
#### .KeepCurrent
.KeepCurrent options sets value for box with current frame's width or height, but result size will be still equal to those original frame values. This is usefull to layout multiline labels. First you need to set somehow label width, and then call something like label.lx.sizeToFit(width: .KeepCurrent, height: .Max).
```swift


icon.lx.set(size: CGSize(width: 200, height: 200))
    .sizeToFit(width: .KeepCurrent, height: .Max)
    .alignTop(10)
    .hcenter()

label.lx.hfill(leftInset: 20, rightInset: 20)
    .sizeToFit(width: .KeepCurrent, height: .Max)
    .center()

title.lx.hfill(leftInset: 20, rightInset: 20)
    .sizeToFit(width: .KeepCurrent, height: .Max)
    .alignBottom(10)
    .hcenter()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.KeepCurrent_portrait.png" alt=".KeepCurrent" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.KeepCurrent_landscape.png" alt=".KeepCurrent" width="240.0" height="160.0"/>
#### Min/Max constraints
SizeToFit operation also can have min, max or both constraints to limit resulted width/height. 
```swift


label.lx
    .sizeToFitMax(widthConstraint: .Max(100), heightConstraint: .Min(300))
    .center()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_Min-Max constraints_portrait.png" alt="Min/Max constraints" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__Min-Max constraints_landscape.png" alt="Min/Max constraints" width="240.0" height="160.0"/>
### Follow
#### Corners
Follow operation makes one view's anchor to be the same with others view anchor. Anchors can be horizontal and vertical, and can be followed only with anchors of the same type
```swift


blueView.lx.set(x: 10, y: 10)
blueView.lx.set(width: 100, height: 100)

greenView.lx.set(width: 50, height: 190)
greenView.lx.leftAnchor.follow(blueView.lx.rightAnchor)
greenView.lx.topAnchor.follow(blueView.lx.bottomAnchor)

redView.lx.set(width: 30, height: 30)
redView.lx.leftAnchor.follow(blueView.lx.leftAnchor)
redView.lx.bottomAnchor.follow(greenView.lx.bottomAnchor)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Corners_portrait.png" alt="Corners" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Corners_landscape.png" alt="Corners" width="240.0" height="160.0"/>
#### Center
There are not only edge anchors, but also center anchors
```swift



blueView.lx.set(x: 10, y: 10)
blueView.lx.set(width: 200)
blueView.lx.vfill(inset: 20)

greenView.lx.set(width: 50, height: 190)
greenView.lx.leftAnchor.follow(blueView.lx.rightAnchor)
greenView.lx.vcenterAnchor.follow(blueView.lx.vcenterAnchor)

redView.lx.set(width: 30, height: 30)
redView.lx.hcenterAnchor.follow(greenView.lx.hcenterAnchor)
redView.lx.vcenterAnchor.follow(greenView.lx.vcenterAnchor)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Center_portrait.png" alt="Center" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Center_landscape.png" alt="Center" width="240.0" height="160.0"/>
#### Size
There are also size anchors
```swift


blueView.lx.set(x: 10)

blueView.lx.set(width: 50)
blueView.lx.vfill(inset: 100)

greenView.lx.heightAnchor.follow(blueView.lx.widthAnchor)
greenView.lx.widthAnchor.follow(blueView.lx.heightAnchor)
greenView.lx.leftAnchor.follow(blueView.lx.rightAnchor)
greenView.lx.topAnchor.follow(blueView.lx.bottomAnchor)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Size_portrait.png" alt="Size" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Size_landscape.png" alt="Size" width="240.0" height="160.0"/>
#### Baseline
Baseline anchor is special. Only Baselinable views have it. For the moment only UILabel is conforming this protocol. Baseline anchor can be first or last (belongs to line first or last line of text).
```swift


label.lx.hfill(inset: 20)
label.lx.sizeToFit(width: .KeepCurrent, height: .Max)
label.lx.center()

blueView.lx.set(height: 30)
greenView.lx.set(height: 30)

blueView.lx.hfill(inset: 20)
greenView.lx.hfill(inset: 20)

blueView.lx.bottomAnchor.follow(label.lx.firstBaselineAnchor)
greenView.lx.topAnchor.follow(label.lx.lastBaselineAnchor)
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Baseline_portrait.png" alt="Baseline" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Baseline_landscape.png" alt="Baseline" width="240.0" height="160.0"/>
### Put
#### Fix
view_to_replace.lx.hput and view_to_replace.lx.vput operations successively layout views in superview in horizontal or vertical direction using intentions. Fix intention means that view size will take exact value, either directly defined or current one
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
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix_portrait.png" alt="Fix" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix_landscape.png" alt="Fix" width="240.0" height="160.0"/>
#### Flex
view_to_replace.lx.hput and view_to_replace.lx.vput operations successively layout views in superview in horizontal or vertical direction using intentions. Flex intention means that view size will take value based weight of flex value. Flex operates only with free space left after Fix intentions
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
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Flex_portrait.png" alt="Flex" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Flex_landscape.png" alt="Flex" width="240.0" height="160.0"/>
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
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix+Flex_portrait.png" alt="Fix+Flex" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix+Flex_landscape.png" alt="Fix+Flex" width="240.0" height="160.0"/>
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
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix+Flex center many views_portrait.png" alt="Fix+Flex center many views" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix+Flex center many views_landscape.png" alt="Fix+Flex center many views" width="240.0" height="160.0"/>
#### Multi
Single intention can be defined for several views, all calculations are doing for first one, and others use its result as is
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
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Multi_portrait.png" alt="Multi" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Multi_landscape.png" alt="Multi" width="240.0" height="160.0"/>
#### Fix+Flex grid
Elegant way to layout views in grid using just one view_to_replace.lx.hput and one view_to_replace.lx.vput
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
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix+Flex grid_portrait.png" alt="Fix+Flex grid" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix+Flex grid_landscape.png" alt="Fix+Flex grid" width="240.0" height="160.0"/>
#### Put labels
HFillVFit is used to fill width and size to fit height for both labels. view_to_replace.lx.vput is used to center group of labels
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
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Put labels_portrait.png" alt="Put labels" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Put labels_landscape.png" alt="Put labels" width="240.0" height="160.0"/>
### Viewport
#### Demo
Combine operation is not only for grouping other operations, but it also defines viewport for them. Viewport can be defined using anchors of any childview, or nil anchor if using superview edges
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
greenView.lx.set(width: 20)

self.lx.inViewport(topAnchor: blueView.lx.bottomAnchor, leftAnchor: greenView.lx.rightAnchor) {
    redView.lx.fill(inset: 5)
}
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Viewport_Demo_portrait.png" alt="Demo" width="160.0" height="240.0"/> <img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Viewport__Demo_landscape.png" alt="Demo" width="240.0" height="160.0"/>
