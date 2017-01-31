//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//


import UIKit

protocol DemoViewProtocol {
    static var title: String {get}
    static var comments: String {get}
}

protocol RowProtocol {
    var title: String {get}
    var comments: String {get}
    var view: UIView {get}
}

struct Row<T: UIView where T: DemoViewProtocol >: RowProtocol {
    var title: String {
        return T.title
    }

    var comments: String {
        return T.comments
    }
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
    
    private var sections = [
        Section(title: "Basic", rows: [
                Row<BasicDemo_Set>(),
                Row<BasicDemo_Center>(),
                Row<BasicDemo_Fill>(),
                Row<BasicDemo_Align>()
            ]),
        Section(title: "SizeToFit", rows:
            [
                Row<SizeToFitDemo_Value>(),
                Row<SizeToFitDemo_Max>(),
                Row<SizeToFitDemo_Current>(),
                Row<SizeToFitDemo_KeepCurrent>(),
                Row<SizeToFitDemo_MinMax>(),
            ]
        ),
        Section(title: "Follow", rows:
            [
                Row<FollowDemo_CornerAnchors>(),
                Row<FollowDemo_CenterAnchors>(),
                Row<FollowDemo_SizeAnchors>(),
                Row<FollowDemo_firstBaselineAnchors>()
            ]
        ),
        Section(title: "Put", rows:
            [
                Row<PutDemo_Fix>(),
                Row<PutDemo_Flex>(),
                Row<PutDemo_FixFlex>(),
                Row<PutDemo_FixFlexCenter>(),
                Row<PutDemo_Multi>(),
                Row<PutDemo_FixFlexGrid>(),
                Row<PutDemo_Labels>()
            ]
        ),
        Section(title: "Viewport", rows:
            [
                Row<ViewPortDemo>()
            ]
        ),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Demos"
        
        view.addSubview(tableView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DocGen", style: .Plain , target: self, action: #selector(docGenClicked))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Table", style: .Plain , target: self, action: #selector(tableClicked))
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
    
    @objc private func docGenClicked() {
        let vc = DocGenViewController(sections: sections)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func tableClicked() {
        let vc = TableViewController()
        navigationController?.pushViewController(vc, animated: true)
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
        let vc = DemoViewController(title: row.title, description: row.comments, demoView: row.view)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

