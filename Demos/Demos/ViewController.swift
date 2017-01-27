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

struct Row<T: UIView>: RowProtocol where T: DemoViewProtocol  {
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
    
    fileprivate lazy var tableView = UITableView(frame: CGRect(), style: .plain)
    
    fileprivate var sections = [
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
                Row<FollowDemo_BaselineAnchors>()
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DocGen", style: .plain , target: self, action: #selector(docGenClicked))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Table", style: .plain , target: self, action: #selector(tableClicked))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    @objc fileprivate func docGenClicked() {
        let vc = DocGenViewController(sections: sections)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func tableClicked() {
        let vc = TableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "CellId"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.textLabel?.text = sections[indexPath.section].rows[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section].rows[indexPath.row]
        let vc = DemoViewController(title: row.title, description: row.comments, demoView: row.view)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

