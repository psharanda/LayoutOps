//
//  Created by Pavel Sharanda on 19.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//


import UIKit
import LayoutOps

struct SampleModel {
    let title: String
    let details: String
}

class TableViewController: UIViewController {
    
    fileprivate lazy var tableView = UITableView(frame: CGRect(), style: .plain)
    
    
    let models = [
        SampleModel(title: "Risus Pharetra Vulputate Ipsum", details: "Cras mattis consectetur purus sit amet fermentum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam porta sem malesuada magna mollis euismod. Sed posuere consectetur est at lobortis."),
        SampleModel(title: "Cras mattis consectetur purus sit amet fermentum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.", details: "Donec ullamcorper nulla non metus auctor fringilla. Donec id elit non mi porta gravida at eget metus."),
        SampleModel(title: "Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Curabitur blandit tempus porttitor.", details: "Donec id elit non mi porta gravida at eget metus. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur et."),
        SampleModel(title: "Ornare Pharetra", details: "Purus Sem Mattis Ridiculus"),
        SampleModel(title: "Risus Pharetra Vulputate Ipsum", details: "Cras mattis consectetur purus sit amet fermentum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam porta sem malesuada magna mollis euismod. Sed posuere consectetur est at lobortis."),
        SampleModel(title: "Cras mattis consectetur purus sit amet fermentum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.", details: "Donec ullamcorper nulla non metus auctor fringilla. Donec id elit non mi porta gravida at eget metus."),
        SampleModel(title: "Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Curabitur blandit tempus porttitor.", details: "Donec id elit non mi porta gravida at eget metus. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur et."),
        SampleModel(title: "Ornare Pharetra", details: "Purus Sem Mattis Ridiculus"),
        SampleModel(title: "Risus Pharetra Vulputate Ipsum", details: "Cras mattis consectetur purus sit amet fermentum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam porta sem malesuada magna mollis euismod. Sed posuere consectetur est at lobortis."),
        SampleModel(title: "Cras mattis consectetur purus sit amet fermentum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.", details: "Donec ullamcorper nulla non metus auctor fringilla. Donec id elit non mi porta gravida at eget metus."),
        SampleModel(title: "Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Curabitur blandit tempus porttitor.", details: "Donec id elit non mi porta gravida at eget metus. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur et."),
        SampleModel(title: "Ornare Pharetra", details: "Purus Sem Mattis Ridiculus")
    ]
    
    var caches: [Int: SampleCell.Cache] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Table Demo"
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "CellId"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellId) as? SampleCell) ?? SampleCell(style: .default, reuseIdentifier: cellId)
        cell.model = models[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? SampleCell)?.cache = caches[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let cache = caches[indexPath.row] {
            return cache.height
        } else {
            let cache = SampleCell.desiredHeight(models[indexPath.row], width: tableView.bounds.width)
            caches[indexPath.row] = cache
            return cache.height
        }
    }
}

class MyView: UIView {
    
    var color: UIColor? {
        set {
            backgroundColor = newValue
        }
        get {
            return backgroundColor
        }
    }
}

class SampleCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let cache = cache else {
            return
        }
        
        cache.rootNode.installInRootView(contentView)
    }
    
    enum Tags: String, Taggable {
        case Title
        case Details
        case Bg1
        case Highlight1
        case Highlight2
    }
    
    struct Cache {
        let height: CGFloat
        let rootNode: RootNode
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let v = contentView.findViewWithTag(Tags.Highlight1) as? MyView {
            v.color = UIColor.red.withAlphaComponent(0.2)
        }
    }
    
    var model: SampleModel?
    var cache: Cache?
    
    static func desiredHeight(_ model: SampleModel, width: CGFloat) -> Cache {
        
        
        let bg1Node = Node(tag: Tags.Bg1) {
            let v = $0 ?? UIView()
            v.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
            return v
        }
        
        let titleNode = LabelNode(tag: Tags.Title, text: .regular(model.title, UIFont.systemFont(ofSize: 24)), numberOfLines: 0, subnodes: [bg1Node]) {
            let v = $0 ?? UILabel()
            v.textColor = UIColor.darkGray
            v.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            return v
        }
        
        let h1Node = Node<MyView>(tag: Tags.Highlight1) {
            let v = $0 ?? MyView()
            
            return v
        }
        
        let p = NSMutableParagraphStyle()
        p.lineSpacing = 3
        p.lineBreakMode = .byTruncatingTail
        
        let attr = NSAttributedString(string: model.details, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSParagraphStyleAttributeName: p])
        
        let detailsNode = LabelNode(tag: Tags.Details, text: .attributed(attr), numberOfLines: 2) {
            let v = $0 ?? UILabel()
            v.textColor = UIColor.gray
            v.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            return v
        }
        
        let h2Node = Node(tag: Tags.Highlight2) {
            let v = $0 ?? UIView()
            v.backgroundColor = UIColor.green.withAlphaComponent(0.2)
            return v
        }
        
        let rootNode = RootNode(size: CGSize(width: width, height: 0), subnodes: [titleNode, detailsNode, h1Node, h2Node])
        
        
        titleNode.lx.hfillvfit(inset: 10)
        detailsNode.lx.hfillvfit(inset: 10)
        
        h1Node.lx.hfill(inset: 10)
        h1Node.lx.set(height: 20)
        
        h2Node.lx.hfill(inset: 10)
        h2Node.lx.set(height: 20)
        
        rootNode.lx.vput(
            Fix(10),
            Fix(titleNode),
            Fix(10),
            Fix(detailsNode)
        )
        
        h1Node.lx.bottomAnchor.follow(titleNode.lx.bottomAnchor)
        h2Node.lx.bottomAnchor.follow(detailsNode.lx.bottomAnchor)
        
        bg1Node.lx.fill()
        
        
        return Cache(height: detailsNode.frame.maxY + 10, rootNode: rootNode)
    }
}

