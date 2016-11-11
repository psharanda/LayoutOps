//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//


import UIKit

protocol RowProtocol {
    var title: String {get}
    var description: String {get}
    var view: UIView {get}
}

struct Row<T: UIView>: RowProtocol {
    let title: String
    let description: String

    var view: UIView {
        return T(frame: CGRect())
    }
}

struct Section {
    let title: String
    let rows: [RowProtocol]
}

class ViewController: UIViewController {
    
    private lazy var tableView = UITableView(frame: CGRect(), style: .Plain)
    
    private static let sizeToFitDesc =
    "SizeToFit operation fits view in defined box using -sizeThatFits: method. Box (width and height) can be defined using different options. "

    private var sections = [
        Section(title: "Basic", rows:
            [
                Row<BasicDemo_Set>(
                    title: "Set*",
                    description: "Set* operations directly manipulate according frame values"),
                Row<BasicDemo_Center>(
                    title: "Center",
                    description: "HCenter (horizontally), VCenter (vertically) and Center (both) operations allows to center view. Insets can be used to adjust center point (see green view, 100 pt from bottom). Size of view usually should be set with previous operations. "),
                Row<BasicDemo_Fill>(
                    title: "Fill",
                    description: "HFill (horizontally), VFill (vertically) and Fill (both) operations make view to fill its superview. Insets can be used to control how much space to left unfilled from the superview edges"),
                Row<BasicDemo_Align>(
                    title: "Align",
                    description: "Align* operations allow to put view relatively to edges of superview. Inset value can be used to determine distance to edge. Size of view usually should be set with previous operations.")
            ]),
        Section(title: "SizeToFit", rows:
            [
                Row<SizeToFitDemo_Value>(
                    title: ".Value",
                    description: sizeToFitDesc + ".Value option sets exact value for box. Result size will be equal or less than it."
                ),
                Row<SizeToFitDemo_Max>(
                    title: ".Max",
                    description: sizeToFitDesc + ".Max option sets infinite value for box. Result size will be most comfortable for view to display content. WARNING: multiline labels are comfortable with single line, don't use .Max for them"
                ),
                Row<SizeToFitDemo_Current>(
                    title: ".Current",
                    description: sizeToFitDesc + ".Current options sets value for box with current frame's width or height."
                ),
                Row<SizeToFitDemo_KeepCurrent>(
                    title: ".KeepCurrent",
                    description: sizeToFitDesc + ".KeepCurrent options sets value for box with current frame's width or height, but result size will be still equal to those original frame values. This is usefull to layout multiline labels. First you need to set somehow label width, and then call something like SizeToFit(label, width: .KeepCurrent, height: .Max)."

                ),
                Row<SizeToFitDemo_MinMax>(
                    title: "Min/Max constraints",
                    description: "SizeToFit operation also can have min, max or both constraints to limit resulted width/height. "
                ),
            ]
        ),
        Section(title: "Follow", rows:
            [
                Row<FollowDemo_CornerAnchors>(
                    title: "Corners",
                    description: "Follow operation sets one view's anchor to be the same with others view anchor. Anchors can be horizontal and vertical, and can be followed only with anchors of the same type."
                ),
                Row<FollowDemo_CenterAnchors>(
                    title: "Center",
                    description: "There are not only edge anchors, but also center anchors."
                ),
                Row<FollowDemo_SizeAnchors>(
                    title: "Size",
                    description: "Ah yes, there are also size anchors. Size is kind of awkward anchor, but why not, it can be followed as well"
                ),
                Row<FollowDemo_BaselineAnchors>(
                    title: "Baseline",
                    description: "Baseline anchor is special. Only Baselinable views have it. For the moment only UILabel is confirmed this protocol. Baseline anchor can be first or last."
                    
                )
            ]
        ),
        Section(title: "Put", rows:
            [
                Row<PutDemo_Fix>(
                    title: "Fix",
                    description: "HPut and VPut operations successively layout views in superview in horizontal or vertical direction using intentions. Fix intention means that view size will take exact value, either directly defined or current one"
                ),
                Row<PutDemo_Flex>(
                    title: "Flex",
                    description: "HPut and VPut operations successively layout views in superview in horizontal or vertical direction using intentions. Flex intention means that view size will take value based weight of flex value. Flex operates only with free space left after Fix intentions"
                ),
                Row<PutDemo_FixFlex>(
                    title: "Fix+Flex",
                    description: "Biggest power comes when we combine Fix and Flex intentions"
                ),
                Row<PutDemo_FixFlexCenter>(
                    title: "Fix+Flex center many views",
                    description: "It is really to easy to center bunch of views all together"
                ),
                Row<PutDemo_Multi>(
                    title: "Multi",
                    description: "Single intention can be defined for several views, all calculations are doing for first one, and others use its result as is"
                    
                ),
                Row<PutDemo_FixFlexGrid>(
                    title: "Fix+Flex grid",
                    description: "Elegant way to layout views in grid using just one HPut and one VPut"
                )
            ]
        ),
        Section(title: "Viewport", rows:
            [
                Row<ViewPortDemo>(
                    title: "Demo",
                    description: "Combine operation not only allows to group other operations, but also define viewport for them. Viewport can be defined using anchors of childview, or nil anchor if using superview edges"
                )
            ]
        ),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Demos"
        
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "CellId"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) ?? UITableViewCell(style: .Default, reuseIdentifier: cellId)
        cell.textLabel?.text = sections[indexPath.section].rows[indexPath.row].title
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = sections[indexPath.section].rows[indexPath.row]
        let vc = DemoViewController(title: row.title, description: row.description, demoView: row.view)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

