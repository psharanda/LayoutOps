### Basic
#### Set*
Set* operations directly manipulate according frame values
```swift


Combine(
    SetOrigin(blueView, x: 10, y: 10),
    SetSize(blueView, width: 100, height: 100),
    
    SetFrame(greenView, x: 120, y: 20, width: 50, height: 190),
    
    SetX(redView, value: 5),
    SetY(redView, value: 120),
    SetWidth(redView, value: 45),
    SetHeight(redView, value: 100)
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Set-_portrait.png" alt="Set*" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Set-_landscape.png" alt="Set*" width="240.0" height="160.0"/>
#### Center
HCenter (horizontally), VCenter (vertically) and Center (both) operations allows to center view. Insets can be used to adjust center point (see green view, 100 pt from bottom). Size of view usually should be set with previous operations
```swift


Combine(
    SetY(blueView, value: 5),
    SetSize(blueView, width: 100, height: 100),
    HCenter(blueView),
    
    SetX(greenView, value: 5),
    SetSize(greenView, width: 50, height: 120),
    VCenter(greenView, topInset: 0, bottomInset: 100),
    
    SetSize(redView, width: 45, height: 100),
    Center(redView)
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Center_portrait.png" alt="Center" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Center_landscape.png" alt="Center" width="240.0" height="160.0"/>
#### Fill
HFill (horizontally), VFill (vertically) and Fill (both) operations make view to fill its superview. Insets can be used to control how much space to left unfilled from the superview edges
```swift


Combine(
    Fill(redView, inset: 5),
    
    SetY(blueView, value: 20),
    SetHeight(blueView, value: 50),
    HFill(blueView, inset: 10),
    
    SetX(greenView, value: 25),
    SetWidth(greenView, value: 50),
    VFill(greenView, topInset: 100, bottomInset: 15)
    
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Fill_portrait.png" alt="Fill" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Fill_landscape.png" alt="Fill" width="240.0" height="160.0"/>
#### Align
Align* operations allow to put view relatively to edges of superview. Inset value can be used to determine distance to edge. Size of view usually should be set with previous operations.
```swift


Combine(            
    SetSize(blueView, width: 100, height: 100),
    AlignLeft(blueView, inset: 5),
    AlignTop(blueView, inset: 5),
    
    SetSize(greenView, width: 50, height: 120),
    AlignLeft(greenView, inset: 10),
    AlignBottom(greenView, inset: 15),
    
    SetSize(redView, width: 45, height: 100),
    AlignRight(redView, inset: 25),
    AlignTop(redView, inset: 25)
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Align_portrait.png" alt="Align" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Align_landscape.png" alt="Align" width="240.0" height="160.0"/>
### SizeToFit
#### .Value
SizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. .Value option sets exact value for box. Result size will be equal or less than it.
```swift


Combine(
    SizeToFit(icon, width: .Value(100), height: .Value(100)),
    AlignTop(icon, inset: 10),
    HCenter(icon),
    
    SizeToFit(label, width: .Value(100), height: .Value(100)),
    Center(label),
    
    SizeToFit(title, width: .Value(100), height: .Value(100)),
    AlignBottom(title, inset: 10),
    HCenter(title)
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.Value_portrait.png" alt=".Value" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.Value_landscape.png" alt=".Value" width="240.0" height="160.0"/>
#### .Max
SizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. .Max option sets infinite value for box. Result size will be most comfortable for view to display content. WARNING: multiline labels are comfortable with single line, don't use .Max for them
```swift


Combine(
    SizeToFitMax(icon),  //same as SizeToFit(view, width: .Max, height: .Max)
    AlignTop(icon, inset: 10),
    HCenter(icon),
    
    SizeToFit(label, width: .Max, height: .Max),
    Center(label),
    
    SizeToFit(title, width: .Max, height: .Max),
    AlignBottom(title, inset: 10),
    HCenter(title)
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.Max_portrait.png" alt=".Max" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.Max_landscape.png" alt=".Max" width="240.0" height="160.0"/>
#### .Current
SizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. .Current options sets value for box with current frame's width or height.
```swift


Combine(
    SetSize(icon, size: CGSize(width: 200, height: 200)),
    SizeToFit(icon, width: .Current, height: .Current),
    AlignTop(icon, inset: 10),
    HCenter(icon),
    
    HFill(label, leftInset: 20, rightInset: 20),
    SizeToFit(label), //same as SizeToFit(view, width: .Current, height: .Current)
    Center(label),
    
    HFill(title, leftInset: 20, rightInset: 20),
    SizeToFit(title, width: .Current, height: .Current),
    AlignBottom(title, inset: 10),
    HCenter(title)
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.Current_portrait.png" alt=".Current" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.Current_landscape.png" alt=".Current" width="240.0" height="160.0"/>
#### .KeepCurrent
SizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. .KeepCurrent options sets value for box with current frame's width or height, but result size will be still equal to those original frame values. This is usefull to layout multiline labels. First you need to set somehow label width, and then call something like SizeToFit(label, width: .KeepCurrent, height: .Max).
```swift


Combine(
    
    SetSize(icon, size: CGSize(width: 200, height: 200)),
    SizeToFit(icon, width: .KeepCurrent, height: .Max),
    AlignTop(icon, inset: 10),
    HCenter(icon),
    
    HFill(label, leftInset: 20, rightInset: 20),
    SizeToFit(label, width: .KeepCurrent, height: .Max),
    Center(label),
    
    HFill(title, leftInset: 20, rightInset: 20),
    SizeToFit(title, width: .KeepCurrent, height: .Max),
    AlignBottom(title, inset: 10),
    HCenter(title)
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.KeepCurrent_portrait.png" alt=".KeepCurrent" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.KeepCurrent_landscape.png" alt=".KeepCurrent" width="240.0" height="160.0"/>
#### Min/Max constraints
SizeToFit operation also can have min, max or both constraints to limit resulted width/height. 
```swift


Combine(
    SizeToFitMaxWithConstraints(label, widthConstraint: .Max(100), heightConstraint: .Min(300)),
    Center(label)
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_Min-Max constraints_portrait.png" alt="Min/Max constraints" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__Min-Max constraints_landscape.png" alt="Min/Max constraints" width="240.0" height="160.0"/>
### Follow
#### Corners
Follow operation sets one view's anchor to be the same with others view anchor. Anchors can be horizontal and vertical, and can be followed only with anchors of the same type.
```swift


Combine(
    SetOrigin(blueView, x: 10, y: 10),
    SetSize(blueView, width: 100, height: 100),            
    
    SetSize(greenView, width: 50, height: 190),
    Follow(RightAnchor(blueView), withAnchor: LeftAnchor(greenView)),
    Follow(BottomAnchor(blueView), withAnchor: TopAnchor(greenView)),
    
    SetSize(redView, width: 30, height: 30),
    Follow(LeftAnchor(blueView), withAnchor: LeftAnchor(redView)),
    Follow(BottomAnchor(greenView), withAnchor: BottomAnchor(redView))
    
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Corners_portrait.png" alt="Corners" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Corners_landscape.png" alt="Corners" width="240.0" height="160.0"/>
#### Center
There are not only edge anchors, but also center anchors.
```swift


Combine(
    SetOrigin(blueView, x: 10, y: 10),
    SetWidth(blueView, value: 200),
    VFill(blueView, inset: 20),
    
    SetSize(greenView, width: 50, height: 190),
    Follow(RightAnchor(blueView), withAnchor: LeftAnchor(greenView)),
    Follow(VCenterAnchor(blueView), withAnchor: VCenterAnchor(greenView)),
    
    SetSize(redView, width: 30, height: 30),
    Follow(HCenterAnchor(greenView), withAnchor: HCenterAnchor(redView)),
    Follow(VCenterAnchor(greenView), withAnchor: VCenterAnchor(redView))
    
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Center_portrait.png" alt="Center" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Center_landscape.png" alt="Center" width="240.0" height="160.0"/>
#### Size
Ah yes, there are also size anchors. Size is kind of awkward anchor, but why not, it can be followed as well
```swift


Combine(
    SetX(blueView, value: 10),
    
    SetWidth(blueView, value: 50),
    VFill(blueView, inset: 100),
    
    Follow(WidthAnchor(blueView), withAnchor: HeightAnchor(greenView)),
    Follow(HeightAnchor(blueView), withAnchor: WidthAnchor(greenView)),
    Follow(RightAnchor(blueView), withAnchor: LeftAnchor(greenView)),
    Follow(BottomAnchor(blueView), withAnchor: TopAnchor(greenView))
    
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Size_portrait.png" alt="Size" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Size_landscape.png" alt="Size" width="240.0" height="160.0"/>
#### Baseline
Baseline anchor is special. Only Baselinable views have it. For the moment only UILabel is confirmed this protocol. Baseline anchor can be first or last.
```swift


Combine(
    
    HFill(label, inset: 20),
    SizeToFit(label, width: .KeepCurrent, height: .Max),
    Center(label),
    
    SetHeight(blueView, value: 30),
    SetHeight(greenView, value: 30),
    
    HFill(blueView, inset: 20),
    HFill(greenView, inset: 20),
    
    Follow(BaselineAnchor(label, type: .First), withAnchor: BottomAnchor(blueView)),
    Follow(BaselineAnchor(label, type: .Last), withAnchor: TopAnchor(greenView))
).layout()
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Baseline_portrait.png" alt="Baseline" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Baseline_landscape.png" alt="Baseline" width="240.0" height="160.0"/>
### Put
#### Fix
HPut and VPut operations successively layout views in superview in horizontal or vertical direction using intentions. Fix intention means that view size will take exact value, either directly defined or current one
```swift


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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix_portrait.png" alt="Fix" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix_landscape.png" alt="Fix" width="240.0" height="160.0"/>
#### Flex
HPut and VPut operations successively layout views in superview in horizontal or vertical direction using intentions. Flex intention means that view size will take value based weight of flex value. Flex operates only with free space left after Fix intentions
```swift


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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Flex_portrait.png" alt="Flex" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Flex_landscape.png" alt="Flex" width="240.0" height="160.0"/>
#### Fix+Flex
Biggest power comes when we combine Fix and Flex intentions
```swift


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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix+Flex_portrait.png" alt="Fix+Flex" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix+Flex_landscape.png" alt="Fix+Flex" width="240.0" height="160.0"/>
#### Fix+Flex center many views
It is really to easy to center bunch of views all together
```swift


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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix+Flex center many views_portrait.png" alt="Fix+Flex center many views" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix+Flex center many views_landscape.png" alt="Fix+Flex center many views" width="240.0" height="160.0"/>
#### Multi
Single intention can be defined for several views, all calculations are doing for first one, and others use its result as is
```swift


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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Multi_portrait.png" alt="Multi" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Multi_landscape.png" alt="Multi" width="240.0" height="160.0"/>
#### Fix+Flex grid
Elegant way to layout views in grid using just one HPut and one VPut
```swift


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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix+Flex grid_portrait.png" alt="Fix+Flex grid" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix+Flex grid_landscape.png" alt="Fix+Flex grid" width="240.0" height="160.0"/>
### Viewport
#### Demo
Combine operation not only allows to group other operations, but also define viewport for them. Viewport can be defined using anchors of childview, or nil anchor if using superview edges
```swift


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
```
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Viewport_Demo_portrait.png" alt="Demo" width="160.0" height="240.0"/><img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Viewport__Demo_landscape.png" alt="Demo" width="240.0" height="160.0"/>
