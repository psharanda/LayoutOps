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
    
    private lazy var tableView = UITableView(frame: CGRect(), style: .Plain)
    
    
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "CellId"
        let cell = (tableView.dequeueReusableCellWithIdentifier(cellId) as? SampleCell) ?? SampleCell(style: .Default, reuseIdentifier: cellId)
        cell.model = models[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as? SampleCell)?.cache = caches[indexPath.row]
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
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
            v.color = UIColor.redColor().colorWithAlphaComponent(0.2)
        }
    }
    
    var model: SampleModel?
    var cache: Cache?
    
    static func desiredHeight(model: SampleModel, width: CGFloat) -> Cache {
        
        
        let bg1Node = Node(tag: Tags.Bg1) {
            let v = $0 ?? UIView()
            v.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.2)
            return v
        }
        
        let titleNode = LabelNode(tag: Tags.Title, text: .Regular(model.title, UIFont.systemFontOfSize(24)), numberOfLines: 0, subnodes: [bg1Node]) {
            let v = $0 ?? UILabel()
            v.textColor = UIColor.darkGrayColor()
            v.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2)
            return v
        }
        
        let h1Node = Node<MyView>(tag: Tags.Highlight1) {
            let v = $0 ?? MyView()
            
            return v
        }
        
        let p = NSMutableParagraphStyle()
        p.lineSpacing = 3
        p.lineBreakMode = .ByTruncatingTail
        
        let attr = NSAttributedString(string: model.details, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12), NSParagraphStyleAttributeName: p])
        
        let detailsNode = LabelNode(tag: Tags.Details, text: .Attributed(attr), numberOfLines: 4) {
            let v = $0 ?? UILabel()
            v.textColor = UIColor.grayColor()
            v.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.2)
            return v
        }
        
        let h2Node = Node(tag: Tags.Highlight2) {
            let v = $0 ?? UIView()
            v.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.2)
            return v
        }
        
        let rootNode = RootNode(size: CGSize(width: width, height: 0), subnodes: [titleNode, detailsNode, h1Node, h2Node])
        
        Combine(
            HFillVFit(titleNode, inset: 10),
            HFillVFit(detailsNode, inset: 10),
            
            HFill(h1Node, inset: 10),
            SetHeight(h1Node, value: 20),
            
            HFill(h2Node, inset: 10),
            SetHeight(h2Node, value: 20),
            
            VPut(
                Fix(10),
                Fix(titleNode),
                Fix(10),
                Fix(detailsNode)
            ),
            
            Follow(BaselineAnchor(titleNode), withAnchor: BottomAnchor(h1Node)),
            Follow(BaselineAnchor(detailsNode), withAnchor: BottomAnchor(h2Node)),
            
            Fill(bg1Node)
        ).layout()
        
        return Cache(height: detailsNode.frame.maxY + 10, rootNode: rootNode)
    }
}

