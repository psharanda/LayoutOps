### Basic
#### Set*
Set* operations directly manipulate according frame values
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Set*_portrait.png" alt="Set*" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Set*_landscape.png" alt="Set*" width="240.0" height="160.0"/>
#### Center
HCenter (horizontally), VCenter (vertically) and Center (both) operations allows to center view. Insets can be used to adjust center point (see green view, 100 pt from bottom). Size of view usually should be set with previous operations
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Center_portrait.png" alt="Center" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Center_landscape.png" alt="Center" width="240.0" height="160.0"/>
#### Fill
HFill (horizontally), VFill (vertically) and Fill (both) operations make view to fill its superview. Insets can be used to control how much space to left unfilled from the superview edges
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Fill_portrait.png" alt="Fill" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Fill_landscape.png" alt="Fill" width="240.0" height="160.0"/>
#### Align
Align* operations allow to put view relatively to edges of superview. Inset value can be used to determine distance to edge. Size of view usually should be set with previous operations.
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic_Align_portrait.png" alt="Align" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Basic__Align_landscape.png" alt="Align" width="240.0" height="160.0"/>
### SizeToFit
#### .Value
SizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. .Value option sets exact value for box. Result size will be equal or less than it.
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.Value_portrait.png" alt=".Value" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.Value_landscape.png" alt=".Value" width="240.0" height="160.0"/>
#### .Max
SizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. .Max option sets infinite value for box. Result size will be most comfortable for view to display content. WARNING: multiline labels are comfortable with single line, don't use .Max for them
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.Max_portrait.png" alt=".Max" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.Max_landscape.png" alt=".Max" width="240.0" height="160.0"/>
#### .Current
SizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. .Current options sets value for box with current frame's width or height.
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.Current_portrait.png" alt=".Current" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.Current_landscape.png" alt=".Current" width="240.0" height="160.0"/>
#### .KeepCurrent
SizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. .KeepCurrent options sets value for box with current frame's width or height, but result size will be still equal to those original frame values. This is usefull to layout multiline labels. First you need to set somehow label width, and then call something like SizeToFit(label, width: .KeepCurrent, height: .Max).
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_.KeepCurrent_portrait.png" alt=".KeepCurrent" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__.KeepCurrent_landscape.png" alt=".KeepCurrent" width="240.0" height="160.0"/>
#### Min/Max constraints
SizeToFit operation also can have min, max or both constraints to limit resulted width/height. 
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit_Min/Max constraints_portrait.png" alt="Min/Max constraints" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/SizeToFit__Min/Max constraints_landscape.png" alt="Min/Max constraints" width="240.0" height="160.0"/>
### Follow
#### Corners
Follow operation sets one view's anchor to be the same with others view anchor. Anchors can be horizontal and vertical, and can be followed only with anchors of the same type.
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Corners_portrait.png" alt="Corners" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Corners_landscape.png" alt="Corners" width="240.0" height="160.0"/>
#### Center
There are not only edge anchors, but also center anchors.
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Center_portrait.png" alt="Center" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Center_landscape.png" alt="Center" width="240.0" height="160.0"/>
#### Size
Ah yes, there are also size anchors. Size is kind of awkward anchor, but why not, it can be followed as well
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Size_portrait.png" alt="Size" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Size_landscape.png" alt="Size" width="240.0" height="160.0"/>
#### Baseline
Baseline anchor is special. Only Baselinable views have it. For the moment only UILabel is confirmed this protocol. Baseline anchor can be first or last.
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow_Baseline_portrait.png" alt="Baseline" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Follow__Baseline_landscape.png" alt="Baseline" width="240.0" height="160.0"/>
### Put
#### Fix
HPut and VPut operations successively layout views in superview in horizontal or vertical direction using intentions. Fix intention means that view size will take exact value, either directly defined or current one
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix_portrait.png" alt="Fix" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix_landscape.png" alt="Fix" width="240.0" height="160.0"/>
#### Flex
HPut and VPut operations successively layout views in superview in horizontal or vertical direction using intentions. Flex intention means that view size will take value based weight of flex value. Flex operates only with free space left after Fix intentions
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Flex_portrait.png" alt="Flex" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Flex_landscape.png" alt="Flex" width="240.0" height="160.0"/>
#### Fix+Flex
Biggest power comes when we combine Fix and Flex intentions
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix+Flex_portrait.png" alt="Fix+Flex" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix+Flex_landscape.png" alt="Fix+Flex" width="240.0" height="160.0"/>
#### Fix+Flex center many views
It is really to easy to center bunch of views all together
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix+Flex center many views_portrait.png" alt="Fix+Flex center many views" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix+Flex center many views_landscape.png" alt="Fix+Flex center many views" width="240.0" height="160.0"/>
#### Multi
Single intention can be defined for several views, all calculations are doing for first one, and others use its result as is
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Multi_portrait.png" alt="Multi" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Multi_landscape.png" alt="Multi" width="240.0" height="160.0"/>
#### Fix+Flex grid
Elegant way to layout views in grid using just one HPut and one VPut
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put_Fix+Flex grid_portrait.png" alt="Fix+Flex grid" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Put__Fix+Flex grid_landscape.png" alt="Fix+Flex grid" width="240.0" height="160.0"/>
### Viewport
#### Demo
Combine operation not only allows to group other operations, but also define viewport for them. Viewport can be defined using anchors of childview, or nil anchor if using superview edges
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Viewport_Demo_portrait.png" alt="Demo" width="160.0" height="240.0"/>
<img src="https://raw.githubusercontent.com/psharanda/LayoutOps/swift-2.3/README/Viewport__Demo_landscape.png" alt="Demo" width="240.0" height="160.0"/>
